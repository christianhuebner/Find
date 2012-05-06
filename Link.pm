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
#     REVISION: 0.8
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
    my $class = shift;
    my $path = shift;
    my $parent = shift;
    my $self  = $class->SUPER::new( $path, $path, $parent );
    return $self;
}

1;
