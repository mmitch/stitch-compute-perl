#!perl
use strict;
use warnings;

package Stitch::Compute::List;

use Moo;

has times => ( is => 'ro', default => 1  );
has elems => ( is => 'ro', default => sub { [] } );


sub to_string {
    my $self = shift;
    my $times = $self->times;
    my $elems = join ' ', map { $_->to_string() } @{$self->elems};
    if ($times == 1) {
	return $elems;
    }
    return sprintf '%dx ( %s )', $times, $elems;
}

1;
