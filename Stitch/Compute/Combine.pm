#!perl
use strict;
use warnings;

package Stitch::Compute::Combine;

use Moo;

has times => ( is => 'ro', default => 1 );


sub to_string {
    my $self = shift;
    return "C".$self->times;
}

1;
