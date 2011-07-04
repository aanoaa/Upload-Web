package Upload::Web::Controller::Root;
# ABSTRACT: Root Controller for Upload::Web
use utf8;
use Moose;
use namespace::autoclean;

use Digest::MD5 qw/md5_hex/;
use File::Spec::Functions;
use File::stat;
use URI::Escape;

BEGIN { extends 'Catalyst::Controller' }

#
# Sets the actions in this controller to be registered with no prefix
# so they function identically to actions created in MyApp.pm
#
__PACKAGE__->config(namespace => '');

=head1 NAME

Upload::Web::Controller::Root - Root Controller for Upload::Web

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=head2 index

The root page (/)

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;
}

=head2 upload

=cut

sub upload :Local {
    my ( $self, $c ) = @_;

    my $upload = $c->req->upload('Filedata');
    if ($upload) {
        my $digest = md5_hex( uri_escape_utf8( $upload->basename ) );

        # save uploaded file
        $upload->copy_to( catfile( $c->config->{upload_dir}, $digest ) );

        # save meta data
        $c->model('DB::Upload')->create(
            {
                md5   => $digest,
                fname => $upload->basename,
            }
        );

        # generate download url
        $c->res->body( $c->uri_for('download', $digest) );
    }
    else {
        Catalyst::Exception->throw(
            message => "cannot find uploaded file from upload request"
        );

        # FIX: send what kind of content when it fails?
        $c->res->body( 'what_the_...');
    }
}

=head2 download

=cut

sub download :Local :Args(1) {
    my ( $self, $c, $digest ) = @_;

    # fetch upload object from db
    my $upload
        = $c->model('DB::Upload')->search({ md5 => $digest })->single;

    # increase download counter
    my $download = $upload->download;
    $upload->download($download++);
    $upload->update;

    my $full_path  = catfile(
        $c->config->{upload_dir},
        $digest,
    );
    if (-f $full_path) {
        #
        # make proper header and send a file
        #
        my $stat          = stat $full_path;
        my $encoded_fname = uri_escape_utf8($upload->fname);
        $encoded_fname = $upload->fname;

        # using Static::Simple plugin's _ext_to_type() private method
        $c->log->debug( $c->_ext_to_type($upload->fname) );
        $c->res->headers->content_length( $stat->size );
        $c->res->headers->last_modified( $stat->mtime );

        my $type = $c->_ext_to_type($upload->fname);
        $c->res->headers->content_type( $type );
        if ($type =~ m|^image/|) {
            $c->res->headers->header(
                "Content-Disposition" => qq{filename="$encoded_fname";},
            );
        }
        else {
            $c->res->headers->header(
                "Content-Disposition" => qq{attachment;filename="$encoded_fname";},
            );
        }

        my $fh = IO::File->new( $full_path, 'r' );
        if ( defined $fh ) {
            binmode $fh;
            $c->res->body( $fh );
        }
        else {
            Catalyst::Exception->throw(
                message => "Unable to open $full_path for reading"
            );
        }
    }
    else {
        Catalyst::Exception->throw(
            message => "$full_path is not exists"
        );
    }
}

=head2 default

Standard 404 error page

=cut

sub default :Path {
    my ( $self, $c ) = @_;
    $c->response->body( 'Page not found' );
    $c->response->status(404);
}

=head2 end

Attempt to render a view, if needed.

=cut

sub end : ActionClass('RenderView') {}

__PACKAGE__->meta->make_immutable;

1;
