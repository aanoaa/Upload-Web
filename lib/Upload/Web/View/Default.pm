package Upload::Web::View::Default;
# ABSTRACT: Upload::Web::View::Default

use strict;
use base 'Catalyst::View::TT';

=head1 SYNOPSIS

    sub action :Local {
        my ($self, $c) = @_;
        # stashed template name automatically like below
        # $c->stash->{template} = 'action.tt'
    }

=head1 DESCRIPTION

Catalyst TTSilex View aim to Silex ecrf web site.

=head1 SEE ALSO

L<Catalyst::Helper::View::TTSilex>

=cut

1;

