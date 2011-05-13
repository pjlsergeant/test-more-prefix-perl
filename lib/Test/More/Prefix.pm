package Test::More::Prefix;

=head1 NAME

Test::More::Prefix - Prefix some test output

=head1 DESCRIPTION

Inject a prefix in to Test::Builder's C<note> and C<diag> output. Useful
for providing context in noisy and repetitive tests

=head1 SYNOPSIS

 use Test::More;
 use Test::More::Prefix qw/test_prefix/;

 note "Bar"; # Print '# Bar'

 test_prefix("Foo");
 note "Baz"; # Print '# Foo: Baz'

 test_prefix('');
 note "Bat"; # Print '# Bat'

=head1 IMPLEMENTATION

Intercepts calls to L<Test::Builder>'s internal C<_print_comment> command and
adds your prefix to all defined lines.

=head1 FUNCTIONS

=head2 test_prefix

Set the prefix. Accepts a string.

=head1 AUTHOR

Peter Sergeant - C<pete@clueball.com> on behalf of
L<http://www.net-a-porter.com/|Net-A-Porter>.

=cut

use strict;
use warnings;
use Test::More;

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(test_prefix);

our $prefix = '';

sub test_prefix {
    $prefix = shift();
}

package Test::More::Prefix::ModifierRole;

use strict;
use warnings;
use Moose::Role;

requires '_print_comment';
requires 'done_testing';

around '_print_comment' => sub {
    my ($orig, $self, $fh, @args) = @_;
    if ( $Test::More::Prefix::prefix &&
        length( $Test::More::Prefix::prefix ) ) {
        @args = map {
            defined $_ ? "${Test::More::Prefix::prefix}: $_" : $_
        } @args;
    }
    return $self->$orig( $fh, @args );
};

before 'done_testing' => sub {
    undef($Test::More::Prefix::prefix);
};

# mst told me to do this :-)
package Test::Builder;
use Moose;
with 'Test::More::Prefix::ModifierRole';

1;

