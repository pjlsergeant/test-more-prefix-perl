package Test::More::Prefix::TB2;

# Load Test::More::Prefix for later versions of Test::Builder

require Exporter;
our @ISA       = qw(Exporter);
our @EXPORT_OK = qw(test_prefix);

our $prefix = '';

sub import { __PACKAGE__->export_to_level( 2, @_ ); }

sub test_prefix {
    $prefix = shift();
}

Test::Stream->shared->munge(
    sub {
        my ( $stream, @e ) = @_;

        for my $e (@e) {
            next unless $prefix;
            next
              unless $e->isa('Test::Stream::Event::Diag')
              || $e->isa('Test::Stream::Event::Note');

            $e->set_message( "$prefix: " . $e->message );
        }
    }
);

1;
