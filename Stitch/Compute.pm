#! perl
use strict;
use warnings;

use Stitch::Compute::Keep;
use Stitch::Compute::Add;
use Stitch::Compute::Combine;
use Stitch::Compute::List;

package Stitch::Compute;


sub adjust_stitches {
    my ($from, $to) = @_;

    my $struct;
    if ($from == $to) {
	$struct = Stitch::Compute::Keep->new(times => $to);
    }
    elsif ($to > $from) {
	$struct = _grow($from, $to);
    }
    else {
	$struct = _shrink($from, $to);
    }

    return $struct->to_string();
}

sub _grow {
    my ($from, $to) = @_;

    return Stitch::Compute::List->new(elems => [
					  Stitch::Compute::Keep->new(times => $from),
					  Stitch::Compute::Add->new(times => $to - $from),
				      ]);
}

sub _shrink {
    my ($from, $to) = @_;

    my $diff = $from - $to;
    return Stitch::Compute::List->new(elems => [
					  Stitch::Compute::Keep->new(times => $to - $diff),
					  Stitch::Compute::Combine->new(times => $diff),
				      ]);
}

1;
