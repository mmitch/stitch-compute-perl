#!perl
use Test::More tests => 13;
use warnings;
use strict;

use Test::Exception;

BEGIN { use_ok('Stitch::Compute') };

subtest 'keep: from 1 to 1' => sub {
    my $result = Stitch::Compute::adjust_stitches(1, 1);
    is($result, 'K1');
};

subtest 'keep: from 50 to 50' => sub {
    my $result = Stitch::Compute::adjust_stitches(50, 50);
    is($result, 'K50');
};

subtest 'add: from 10 to 11' => sub {
    my $result = Stitch::Compute::adjust_stitches(10, 11);
    is($result, 'K5 A1 K5');
};

subtest 'add: from 10 to 20' => sub {
    my $result = Stitch::Compute::adjust_stitches(10, 20);
    is($result, '10x ( K1 A1 )');
};

subtest 'add: from 70 to 112' => sub {
    my $result = Stitch::Compute::adjust_stitches(70, 112);
    is($result, '14x ( K1 A1 K1 A1 K2 A1 K1 )');
};

subtest 'combine: from 53 to 48' => sub {
    my $result = Stitch::Compute::adjust_stitches(53, 48);
    is($result, 'K5 C1 K8 C1 K9 C1 K8 C1 K9 C1 K4');
};

subtest 'combine: from 30 to 25' => sub {
    my $result = Stitch::Compute::adjust_stitches(30, 25);
    is($result, '5x ( K2 C1 K2 )');
};

subtest 'combine: from 8 to 5' => sub {
    my $result = Stitch::Compute::adjust_stitches(8, 5);
    is($result, 'K1 C2 K1 C1');
};

subtest 'combine: from 112 to 70' => sub {
    my $result = Stitch::Compute::adjust_stitches(112, 70);
    is($result, '14x ( K1 C2 K1 C1 )');
};

subtest 'combine: from 113 to 70' => sub {
    my $result = Stitch::Compute::adjust_stitches(113, 70);
    is($result, 'K1 C2 K1 C2 K1 C1 K1 C2 K1 C1 K1 C2 K1 C2 K1 C1 K1 C2 K1 C1 K1 C2 K1 C2 K1 C1 K1 C2 K1 C1 K1 C2 K1 C2 K1 C1 K1 C2 K1 C1 K1 C2 K1 C2 K1 C1 K1 C2 K1 C1 K1 C2 K1 C1');
};

subtest 'error: more than double does not work' => sub {
    my $result = Stitch::Compute::adjust_stitches(20, 41);
    is($result, 'ERROR: too many stitches to add - 20 can grow to 40 max');
};

subtest 'error: less than half does not work' => sub {
    my $result = Stitch::Compute::adjust_stitches(30, 14);
    is($result, 'ERROR: too few stitches to keep - 30 can shrink to 15 min');
};
