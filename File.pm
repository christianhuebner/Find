package File;

#
#===============================================================================
#
#         FILE: File.pm
#
#  DESCRIPTION: File class
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
#        CLASS: File
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
    $self->{TOTALSIZE} = $self->{SIZE};
    return $self;
}

1;
