package Node;

use strict;
use warnings;

# Superclass for directory, file, link

sub new {
    my $class = shift;
	my $path = shift;
    my $self  = {
        PATH   => shift,
        PARENT => shift,
    };
    bless( $self, $class );
    $self->initialize();
    return $self;
}

sub initialize {
    my $self = shift;
    my @statkeys =
      qw(DEVICE INODE MODE NLINK UID GID RDEV SIZE ATIME MTIME CTIME BLKSIZE BLOCKS);
    @{$self}{@statkeys} = stat( $self->{PATH} );

    #print $self->{"SIZE"}."\n";
    return;
}    ## --- end sub populate

sub getpath {
    my $self = shift;
    return $self->{PATH};
}

sub getdata {
    my $self = shift;
    my $key  = shift;
    return $self->{$key};
}

sub setparent {
    my $self = shift;
    push( @{ $self->{PARENT} }, $_ );
    return;
}

sub getsize {
    my $self = shift;
    return $self->{SIZE};
}

1;
