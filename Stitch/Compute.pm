#! perl
use strict;
use warnings;

package Stitch::Compute;

use Math::Utils qw(:utility);

use Stitch::Compute::Add;
use Stitch::Compute::Combine;
use Stitch::Compute::Error;
use Stitch::Compute::Keep;
use Stitch::Compute::List;

sub adjust_stitches {
    my ($from, $to) = @_;

    return _adjust($from, $to)->to_string();
}

sub _adjust {
    my ($from, $to) = @_;

    if ($from == $to) {
	return Stitch::Compute::Keep->new(times => $from);
    }

    my $max = 2*$from;
    my $min = int(($from + 1)/2);
    if ($to > $max) {
	return Stitch::Compute::Error->new(error => "too many stitches to add - $from can grow to $max max");
    }

    if ($to < $min) {
	return Stitch::Compute::Error->new(error => "too few stitches to keep - $from can shrink to $min min");
    }

    my $repeats = gcd( $from, $to );
    return Stitch::Compute::List->new(
	times => $repeats,
	elems => [ _adjust_evenly($from / $repeats, $to / $repeats) ]);
}

sub _adjust_evenly {
    my ($from, $to) = @_;

    my $diff = $to - $from;

    my $actions = '';

    my $grow   = $to > $from;
    my $shrink = $to < $from;

    my $oldpos = 0;
    my $newpos = 0;
    while ($oldpos < $from or $newpos < $to) {
	my $diff = ( $oldpos ) - ($newpos / $to * $from);

	if ($diff < 0 and $shrink) {
	    $actions .= "C";
	    $oldpos++;
	    $oldpos++;
	    $newpos++;
	}
	elsif ($diff > 0 and $grow) {
	    $actions .= "A";
	    $newpos++;
	}
	else {
	    $actions .= "K";
	    $oldpos++;
	    $newpos++;
	}
    }

    # normalize: balance head and tail
    $actions =~ /^(([KCA])\2*)/;
    my ($head, $head_what) = ($1, $2);
    $actions =~ /(([KCA])\2*)$/;
    my ($tail, $tail_what) = ($1, $2);

    if (length $actions != $to) {
	printf STDERR "\n*** %d != %d<%s>\n", $to, length $actions, $actions;
	die "*** final length != expected length";
    }

    if ($head_what eq $tail_what) {
	my $head_length = length $head;
	my $tail_length = length $tail;
	# TODO: compute once instead of loop
	while ($head_length > $tail_length) {
	    $actions = substr($actions, 1) . $head_what;
	    $head_length--;
	    $tail_length++;
	}
	while ($head_length < $tail_length) {
	    $actions = $tail_what . substr($actions, 0, -1);
	    $head_length++;
	    $tail_length--;
	}
    }

    my @actions;
    while ($actions =~ s/^(([KCA])\2*)//) {
	my $count = length $1;
	if ($2 eq 'K') {
	    push @actions, Stitch::Compute::Keep->new(times => $count);
	}
	elsif ($2 eq 'C') {
	    push @actions, Stitch::Compute::Combine->new(times => $count);
	}
	elsif ($2 eq 'A') {
	    push @actions, Stitch::Compute::Add->new(times => $count);
	}
	else {
	    die "unknown action type $2";
	}
    }

    return Stitch::Compute::List->new(elems => \@actions);
}

1;
