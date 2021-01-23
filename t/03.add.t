#!perl
use Test::More tests => 3;
use warnings;
use strict;

use Test::Exception;

BEGIN { use_ok('Stitch::Compute::Add') };

subtest 'default times is 1' => sub {
    my $result = Stitch::Compute::Add->new();
    is($result->to_string(), 'A1');
};

subtest 'set times' => sub {
    my $result = Stitch::Compute::Add->new(times => 7);
    is($result->to_string(), 'A7');
};
