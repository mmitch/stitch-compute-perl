#!perl
use Test::More tests => 3;
use warnings;
use strict;

use Test::Exception;

BEGIN { use_ok('Stitch::Compute::Error') };

subtest 'default message is unspecified' => sub {
    my $result = Stitch::Compute::Error->new();
    is($result->to_string(), 'ERROR: unspecified error');
};

subtest 'set message' => sub {
    my $result = Stitch::Compute::Error->new(error => 'some error message');
    is($result->to_string(), 'ERROR: some error message');
};
