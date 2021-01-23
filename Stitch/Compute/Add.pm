#!perl
use strict;
use warnings;

package Stitch::Compute::Add;

use Moo;

has times => ( is => 'ro', default => 1 );


sub to_string {
    my $self = shift;
    return "A".$self->times;
}

1;
