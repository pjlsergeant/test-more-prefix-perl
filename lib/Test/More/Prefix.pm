package Test::More::Prefix;

=head1 NAME

Test::More::Prefix - Prefix some test output

=head1 DESCRIPTION

Inject a prefix in to Test::Builder's informational output. Useful for
providing context in noisy and repetitive tests

=head1 SYNOPSIS

 use Test::More;
 use Test::More::Prefix qw/test_prefix/;

 note "Bar"; # Print '# Bar'

 test_prefix("Foo");
 note "Baz"; # Print '# Foo: Baz'

 test_prefix('');
 note "Bat"; # Print '# Bat'

=head1 IMPLEMENTATION

=head2 Test::Builder

For versions of L<Test::Simple> which use the original L<Test::Builder>
underneath, intercepts calls to L<Test::Builder>'s internal C<_print_comment>
command and adds your prefix to all defined lines.

=head2 TB2

For versions of L<Test::Simple> which use this new-fangled TB2 stuff, we
wrap setting of L<TB2::Event::Log>'s C<message> attribute to prepend the
prefix. This means that more of the possible output contains the prefix.

=head1 FUNCTIONS

=head2 test_prefix

Set the prefix. Accepts a string.

=head1 AUTHOR

Peter Sergeant - C<pete@clueball.com> on behalf of
L<Net-A-Porter|http://www.net-a-porter.com/>.

=cut

use strict;
use warnings;
use Test::More;

# Version of Test::Builder that's really TB2. I suspect there are some perverse
# cases where you may need/want to over-ride this
our $MAGIC_TEST_BUILDER_NUMBER = 1.005000;

sub import {
    my ( $class, @args ) = @_;
    my $version = $Test::Builder::VERSION;
    if ( $version >= $MAGIC_TEST_BUILDER_NUMBER ) {
        require Test::More::Prefix::TB2;
        Test::More::Prefix::TB2->import(@args);
    } else {
        require Test::More::Prefix::TB1;
        Test::More::Prefix::TB1->import(@args);
    }
}

1;
