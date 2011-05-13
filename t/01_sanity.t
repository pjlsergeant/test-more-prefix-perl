#!perl

use strict;
use warnings;

use Test::More;
use Test::More::Prefix qw/test_prefix/;

test_prefix("Sample test prefix");
note "<-- Should be 'Sample test prefix: '";
ok(1, "Nothing seems to have died");

done_testing;
