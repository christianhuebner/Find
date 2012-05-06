package File;

use strict;
use warnings;
use Node;

use base qw( Node );

sub new {
    my $class = shift;
    my $path = shift;
    my $parent = shift || "none";
    my $self  = $class->SUPER::new( my $dummy, $path, $parent );
    $self->{PARENT} = shift;
    return $self;
}

1;
