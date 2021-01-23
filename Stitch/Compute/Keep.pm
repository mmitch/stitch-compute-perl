#!perl
use strict;
use warnings;

package Stitch::Compute::Keep;

use Moo;

has times => ( is => 'ro', default => 1 );


sub to_string {
    my $self = shift;
    return "K".$self->times;
}

1;
