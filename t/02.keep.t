#!perl
use Test::More tests => 3;
use warnings;
use strict;

use Test::Exception;

BEGIN { use_ok('Stitch::Compute::Keep') };

subtest 'default times is 1' => sub {
    my $result = Stitch::Compute::Keep->new();
    is($result->to_string(), 'K1');
};

subtest 'set times' => sub {
    my $result = Stitch::Compute::Keep->new(times => 28);
    is($result->to_string(), 'K28');
};
