#!perl
use Test::More tests => 3;
use warnings;
use strict;

use Test::Exception;

BEGIN { use_ok('Stitch::Compute::Combine') };

subtest 'default times is 1' => sub {
    my $result = Stitch::Compute::Combine->new();
    is($result->to_string(), 'C1');
};

subtest 'set times' => sub {
    my $result = Stitch::Compute::Combine->new(times => 7);
    is($result->to_string(), 'C7');
};
