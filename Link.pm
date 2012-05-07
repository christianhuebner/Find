package Link;

#
#===============================================================================
#
#         FILE: Link.pm
#
#  DESCRIPTION: Link class
#
#       AUTHOR: Christian Huebner <christian.huebner@linuxwisdom.com>
# ORGANIZATION: LinuxWisdom, Inc.
#      CREATED: 05/06/2012
#     REVISION: 
#===============================================================================

use strict;
use warnings;
use Node;

use base qw( Node );

#===  CLASS METHOD  ============================================================
#        CLASS: Link
#       METHOD: new
#   PARAMETERS: path, parent node
#      RETURNS: Reference to itself
#  DESCRIPTION: Currently only calls superclass constructor
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub new {
    my $class  = shift;
    my $path   = shift;
    my $parent = shift;
    my $self   = $class->SUPER::new( $path, $path, $parent );

    $self->populate();
    return $self;
}

#===  CLASS METHOD  ============================================================
#        CLASS: Link
#       METHOD: populate
#   PARAMETERS: none
#      RETURNS: nothing
#  DESCRIPTION: Populate link node with link specific data
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub populate {
    my $self = shift;
    $self->{LINKTARGET} = readlink( $self->{PATH} );
    if ( $self->{LINKTARGET} ) {
        $self->{LINKABSOLUTE} = ( $self->{LINKTARGET} =~ m/^\//x );
    }
    $self->{TOTALSIZE} = length( $self->{LINKTARGET} ) | 0;
    return;
}

1;
