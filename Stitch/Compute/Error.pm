#!perl
use strict;
use warnings;

package Stitch::Compute::Error;

use Moo;

has error => ( is => 'ro', default => 'unspecified error' );


sub to_string {
    my $self = shift;
    return 'ERROR: ' . $self->error;
}

1;
