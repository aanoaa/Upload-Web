#!/usr/bin/env perl
use strict;
use warnings;
use Upload::Web;

Upload::Web->setup_engine('PSGI');
my $app = sub { Upload::Web->run(@_) };

