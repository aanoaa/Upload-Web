package Upload::Web::Controller::Root;
# ABSTRACT: Root Controller for Upload::Web
use Moose;
use utf8;
use Digest::MD5 qw/md5_hex/;
use namespace::autoclean;

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
    my $upload  = $c->req->upload('Filedata');
    my $name = $upload->basename;
    my $digest = md5_hex($name);
    $upload->copy_to($c->config->{upload_dir} . "/$digest") if $upload;

    $c->model('DB::Upload')->create({
        md5 => $digest,
        fname => $name
    });

    my $uri = $c->uri_for('download', $digest);
    $c->res->body($uri);
}

=head2 download

=cut

sub download :Local :Args(1) {
    my ( $self, $c, $digest ) = @_;

    my $upload = $c->model('DB::Upload')->search({
        md5 => $digest   
    })->single;

    my $fname = $upload->fname;
    my $download = $upload->download;
    $upload->download($download++);
    $upload->update;


    my $upload_dir = $c->config->{upload_dir};
    my $output_file = "$upload_dir/$digest";
    my @st = stat($output_file) or die "No $output_file: $!";
    $c->res->headers->content_type('application/octet-stream');
    $c->res->headers->content_length($st[7]);
    $c->res->headers->header("Content-Disposition" => 'attachment;filename="' . $fname . '";');
    my $fh = IO::File->new( $output_file, 'r' );
    $c->res->body($fh);
    undef $fh;
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
