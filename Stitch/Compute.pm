#! perl
use strict;
use warnings;

package Stitch::Compute;

use Math::Utils qw(:utility);

use Stitch::Compute::Keep;
use Stitch::Compute::Add;
use Stitch::Compute::Combine;
use Stitch::Compute::List;

sub adjust_stitches {
    my ($from, $to) = @_;

    my $struct;
    if ($from == $to) {
	$struct = Stitch::Compute::Keep->new(times => $to);
    }
    else {
	my $repeats = gcd( $from, $to );

	$struct = Stitch::Compute::List->new(
	    times => $repeats,
	    elems => [ _adjust_evenly($from / $repeats, $to / $repeats) ]);
    }

    return $struct->to_string();
}

sub _adjust_evenly {
    my ($from, $to) = @_;

    my $diff = $to - $from;

    if ($diff > 0) {

	return Stitch::Compute::List->new(elems => [
					      Stitch::Compute::Keep->new(times => $from),
					      Stitch::Compute::Add->new(times => $diff),
					  ]);

    }
    else {
	return Stitch::Compute::List->new(elems => [
					      Stitch::Compute::Keep->new(times => $to + $diff),
					      Stitch::Compute::Combine->new(times => -$diff),
					  ]);
    }
}

1;
