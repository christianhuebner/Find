package Node;

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
#     REVISION: 
#===============================================================================

use strict;
use warnings;

#===  CLASS METHOD  ============================================================
#        CLASS: Node
#       METHOD: new
#   PARAMETERS: path, parent node reference
#      RETURNS: reference to itself
#  DESCRIPTION: Superclass of Directory, File and Link
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub new {
    my $class = shift;
    my $path  = shift;
    my $self  = {
        PATH   => shift,
        PARENT => shift,
    };
    bless( $self, $class );
    $self->initialize();
    return $self;
}

#===  CLASS METHOD  ============================================================
#        CLASS: Node
#       METHOD: initialize
#   PARAMETERS: none
#      RETURNS: nothing
#  DESCRIPTION: populates node structure with filesystem item stats
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub initialize {
    my $self = shift;
    my @statkeys =
      qw(DEVICE INODE MODE NLINK UID GID RDEV SIZE ATIME MTIME CTIME BLKSIZE BLOCKS);
    @{$self}{@statkeys} = stat( $self->{PATH} );

    return;
}

#===  CLASS METHOD  ============================================================
#        CLASS: Node
#       METHOD: getitem
#   PARAMETERS: data key
#      RETURNS: value for data key
#  DESCRIPTION: generic fetch function for class data
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub getitem {
    my $self = shift;
    my $key  = shift;
    return $self->{$key};
}

1;
