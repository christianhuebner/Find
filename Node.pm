#
#===============================================================================
#
#         FILE: Node.pm
#
#  DESCRIPTION: Node class, parent of Directory.pm, File.pm and Link.pm
#
#       AUTHOR: Christian Huebner <christian.huebner@linuxwisdom.com>
# ORGANIZATION: LinuxWisdom, Inc.
#      CREATED: 05/06/2012
#     REVISION: 0.8
#===============================================================================


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

sub getitem {
    my $self = shift;
	my $key = shift;
    return $self->{$key};
}

1;
