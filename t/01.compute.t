#!perl
use Test::More tests => 5;
use warnings;
use strict;

use Test::Exception;

BEGIN { use_ok('Stitch::Compute') };

subtest 'from 1 to 1' => sub {
    my $result = Stitch::Compute::adjust_stitches(1, 1);
    is($result, 'K1');
};

subtest 'from 50 to 50' => sub {
    my $result = Stitch::Compute::adjust_stitches(50, 50);
    is($result, 'K50');
};

subtest 'from 10 to 11' => sub {
    my $result = Stitch::Compute::adjust_stitches(10, 11);
    is($result, 'K10 A1');
};

subtest 'from 53 to 48' => sub {
    my $result = Stitch::Compute::adjust_stitches(53, 48);
    is($result, 'K43 C5');
};
