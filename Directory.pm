package Directory;

#
#===============================================================================
#
#         FILE: Directory.pm
#
#  DESCRIPTION: Class for directory nodes, inherits node structure from node.pm
#
#       AUTHOR: Christian Huebner <christian.huebner@linuxwisdom.com>
# ORGANIZATION: LinuxWisdom, Inc.
#      CREATED: 05/06/2012
#     REVISION: 0.8
#     REQUIRES: Node.pm, File.pm, Perl 5.10 or above
#===============================================================================

use strict;
use warnings;
use feature "switch";    # Allow Perl 5.10+ given/when statement

use Node;
use base qw(Node);       # Inherit from class Node
use File;
use Link;

#===  CLASS METHOD  ============================================================
#        CLASS: Directory
#       METHOD: new
#   PARAMETERS: Full path to node
#      RETURNS: Reference to itself
#  DESCRIPTION: Constructor for directory
#        CALLS: Superclass constructor
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub new {
    my $class  = shift;
    my $path   = shift;
    my $parent = shift || "none";

    my $self = $class->SUPER::new( $path, $path, $parent );

    # Additional class members for directories only
    $self->{DIRCHILDREN}  = [];
    $self->{FILECHILDREN} = [];
    $self->{LINKCHILDREN} = [];
    $self->{TOTALSIZE}    = 0;
    $self->{TOTALFILES}   = 0;
    $self->{TOTALDIRS}    = 0;
    $self->{TOTALLINKS}   = 0;

    $self->populate();   # Create nodes for all dirs and files in this directory
    $self->collect();    # Collect stats for dirs and files in this directory
    return $self;
}

#===  CLASS METHOD  ============================================================
#        CLASS: Directory
#       METHOD: populate
#   PARAMETERS: none
#      RETURNS: nothing
#  DESCRIPTION: Populates the node with directory, file and link child nodes
#       THROWS: no exceptions
#     COMMENTS: Called from constructor
#     SEE ALSO: n/a
#===============================================================================
sub populate {
    my $self = shift;

    # Acquire directory contents
    opendir( D, $self->{PATH} )
      || die "Cannot open directory " . $self->{PATH} . "\n";
    my @dircontent = readdir(D);
    closedir(D);

    # Iterate over directory contents and create file and directory nodes
    foreach (@dircontent) {
		# Ignore . and .., they are no children of this directory
        if ( /^\.$/x || /^\.\.$/x ) { next; }    
        my $path = $self->{PATH} . "/" . $_;
      	# Create and attach Directory, File and Link child objects to current node
        given ($path) {
            when (-l) {
                push( @{ $self->{LINKCHILDREN} }, Link->new( $_, $self ) );
            }
            when (-d) {
                push( @{ $self->{DIRCHILDREN} }, Directory->new( $_, $self ) );
            }
            when (-f) {
                push( @{ $self->{FILECHILDREN} }, File->new( $_, $self ) );
            }
        }
    }
    return;
}

#===  CLASS METHOD  ============================================================
#        CLASS: Directory
#       METHOD: collect
#   PARAMETERS: none
#      RETURNS: nothing
#  DESCRIPTION: Collect size, number of files, directories and links from child
#       THROWS: no exceptions
#     COMMENTS: none
#     SEE ALSO: n/a
#===============================================================================
sub collect {
    my $self = shift;
    $self->{TOTALSIZE} += $self->{SIZE};    # Size of this directory
    ( $self->{TOTALDIRS}++ ) if ( $self->{PARENT} eq "none" );
    $self->{TOTALDIRS} +=
      @{ $self->{DIRCHILDREN} };            # Count this directory's children
    $self->{TOTALFILES} += @{ $self->{FILECHILDREN} };
    $self->{TOTALLINKS} += @{ $self->{LINKCHILDREN} };
    foreach (
        @{ $self->{FILECHILDREN} },
        @{ $self->{DIRCHILDREN} },
        @{ $self->{LINKCHILDREN} }
      )
    {
        $self->{TOTALSIZE} +=
          $_->getitem("TOTALSIZE");         # Add total sizes of all children
    }
    foreach ( @{ $self->{DIRCHILDREN} } ) {
        $self->{TOTALDIRS}  += $_->getitem("TOTALDIRS");
        $self->{TOTALFILES} += $_->getitem("TOTALFILES");
        $self->{TOTALLINKS} += $_->getitem("TOTALLINKS");
    }
    foreach ( @{ $self->{LINKCHILDREN} } ) {
    }
    return;
}

1;
