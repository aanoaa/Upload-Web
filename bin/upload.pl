#!/usr/bin/env perl

use 5.010;
use utf8;
use strict;
use warnings;
use autodie;
use Getopt::Long::Descriptive;
use Const::Fast;
use LWP;
use File::Basename;

const my $SERVER   => 'http://hshong.net:8080/upload';

binmode STDIN,  ':utf8';
binmode STDOUT, ':utf8';

my ( $opt, $usage ) = describe_options(
    "%c %o <file> [ <file> ... ]",
    [
        'server|s=s',
        "server address (default: $SERVER)",
        { default => $SERVER },
    ],
    [ 'verbose|v', 'print extra stuff', { default => 0 } ],
    [ 'help|h',    'print usage message and exit'        ],
);

print($usage->text), exit if     $opt->help;
print($usage->text), exit unless @ARGV;

for my $file ( @ARGV ) {
    warn "$file is not exists\n", next unless -f $file;

    my $ret = upload($file);
    say $ret if $ret;
}

sub upload {
    my $file = shift;

    ( my $type = (fileparse( $file, qr/\.[^.]*/ ))[2] ) =~ s/^\.//;
    unless ($type) {
        warn "cannot upload $file\n";
        return;
    }

    my $ua = LWP::UserAgent->new;

    my $res = $ua->post(
        sprintf('%s/%s', $opt->server, $type),
        [
            'Filedata' => [ $file ],
        ],
        'Content_Type' => 'form-data',
    );

    unless ($res->is_success) {
        warn "Error: ", $res->status_line, "\n";
        return;
    }

    return $res->content;
}
