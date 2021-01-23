#!perl
use strict;
use warnings;

package Stitch::Compute::List;

use Moo;

use MooX::Types::MooseLike::Base qw(ArrayRef Int);

has times => ( is => 'ro', default => 1, isA => Int );
has elems => ( is => 'ro', default => sub { [] }, isA => ArrayRef );

sub BUILDARGS {
    my ($class, %args) = @_;

    my $elems = delete $args{elems};
    if ($elems) {
	$args{elems} = _flatten($elems);
    }

    return \%args;
}

sub to_string {
    my ($self) = @_;
    my $times = $self->times;
    my $elems = join ' ', map { $_->to_string() } @{$self->elems};
    if ($times == 1) {
	return $elems;
    }
    return sprintf '%dx ( %s )', $times, $elems;
}

sub _flatten {
    my ($elems) = @_;

    my @flattened = map {

	if ($_->isa('Stitch::Compute::List') and $_->times == 1) {
	    @{$_->elems}
	}
	else {
	    $_
	}

    } @{$elems};

    return \@flattened;
}

1;
