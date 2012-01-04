package Test::More::Prefix::TB2;

# Load Test::More::Prefix for later versions of Test::Builder

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(test_prefix);

our $prefix = '';

sub import { __PACKAGE__->export_to_level(2, @_); }

sub test_prefix {
    $prefix = shift();
}

package Test::More::Prefix::ModifierRole::Message;

use strict;
use warnings;
use TB2::Mouse::Role;

requires 'message';

around BUILDARGS => sub {
    my $orig  = shift;
    my $class = shift;
    my %args  = @_;

    if ( $prefix ) {
        $args{'message'} = "$prefix: " . $args{'message'};
    }

    return $class->$orig( %args );
};

around 'message' => sub {
    my $orig = shift;
    my $self = shift;
    return $self->$orig() unless @_;

    my $message = shift;
    $message = "$prefix: $message" if $prefix;

    return $self->$orig($message, @_);
};

no Mouse;

package Test::More::Prefix::ModifierRole::DoneTesting;

use strict;
use warnings;
use TB2::Mouse::Role;

requires 'done_testing';

before 'done_testing' => sub {
    undef($Test::More::Prefix::prefix);
};

no Mouse;


# mst told me to do this :-)
package TB2::Event::Log;
use TB2::Mouse;
with 'Test::More::Prefix::ModifierRole::Message';

# mst told me to do this :-)
package Test::Builder;
use TB2::Mouse;
with 'Test::More::Prefix::ModifierRole::DoneTesting';

1;