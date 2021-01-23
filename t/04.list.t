#!perl
use Test::More tests => 7;
use warnings;
use strict;

use Test::Exception;

{
    package Mock;
    use Moo;
    has string => ( is => 'ro', required => 1 );
    sub to_string { return $_->string };
}

BEGIN { use_ok('Stitch::Compute::List'); };

subtest 'default is empty' => sub {
    my $result = Stitch::Compute::List->new();
    is($result->to_string(), '');
};

subtest 'default times is 1' => sub {
    my $result = Stitch::Compute::List->new(elems => [ Mock->new(string => 'Mock') ] );
    is($result->to_string(), 'Mock');
};

subtest 'elements are separated by spaces' => sub {
    my $result = Stitch::Compute::List->new(elems => [ Mock->new(string => 'A'),
						       Mock->new(string => 'B'),
						       Mock->new(string => 'C'),
					    ] );
    is($result->to_string(), 'A B C');
};

subtest 'repetition given when greater than 1' => sub {
    my $result = Stitch::Compute::List->new(times => 3,
					    elems => [ Mock->new(string => 'A'),
						       Mock->new(string => 'B'),
					    ] );
    is($result->to_string(), '3x ( A B )');
};

subtest 'nested lists are flattened if inner repetition is 1' => sub {
    my $inner = Stitch::Compute::List->new(times => 1,
					   elems => [ Mock->new(string => 'A'),
						      Mock->new(string => 'B'),
					   ] );
    my $outer = Stitch::Compute::List->new(times => 2,
					   elems => [ Mock->new(string => 'C'),
						      $inner,
						      Mock->new(string => 'D'),
					   ] );
    is($outer->to_string(), '2x ( C A B D )');
    is(scalar @{$outer->elems}, 4);
};

subtest 'nested lists are kept if inner repetition more than 1' => sub {
    my $inner = Stitch::Compute::List->new(times => 2,
					   elems => [ Mock->new(string => 'A'),
						      Mock->new(string => 'B'),
					   ] );
    my $outer = Stitch::Compute::List->new(times => 2,
					   elems => [ Mock->new(string => 'C'),
						      $inner,
						      Mock->new(string => 'D'),
					   ] );
    is($outer->to_string(), '2x ( C 2x ( A B ) D )');
    is(scalar @{$outer->elems}, 3);
};
