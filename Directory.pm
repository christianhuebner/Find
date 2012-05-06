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


package Directory;

use strict;
use warnings;
use feature "switch";    # Allow Perl 5.10+ given/when statement

use Node;
use base qw(Node);       # Inherit from class Node
use File;

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
	# Containers for child node references
    $self->{ DIRCHILDREN  => [], FILECHILDREN => [], LINKCHILDREN => [] };
	# Additional stats for directories only
    $self->{ TOTALSIZE => 0, TOTALFILES => 0, TOTALDIRS => 0, TOTALLINKS => 0 };

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
    opendir( D, $self->{PATH} ) || die "Cannot open directory " . $self->{PATH} . "\n";
    my @dircontent = readdir(D);
    closedir(D);

	# Iterate over directory contents and create file and directory nodes
    foreach (@dircontent) {
        if ( /^\.$/x || /^\.\.$/x ) { next; }   # Ignore . and .., they are no children of this directory
        my $path = $self->{PATH} . "/" . $_;
        given ($path) {
            when (-l) {  next; }
            when (-d) { $self->adddir($_); }
            when (-f) { $self->addfile($_); }
        }
    }
    return;
}

sub collect {
    my $self = shift;
    $self->{TOTALSIZE} += $self->{SIZE};    # Size of this directory
    foreach ( @{ $self->{FILECHILDREN} } )
    {    # Size of files directly attached to this directory
        $self->{TOTALSIZE} += $_->getitem("SIZE");
    }
    foreach ( @{ $self->{DIRCHILDREN} } )
    {    # Totalsize of all directories attached to this directory
        $self->{TOTALSIZE} += $_->getitem("TOTALSIZE");
    }
    print $self->{PATH} . " Size: " . $self->{TOTALSIZE} . "\n";
    return;
}

sub adddir {
    my $self    = shift;
    my $dirname = shift;
    my $newdir  = Directory->new( $dirname, $self );
    push( @{ $self->{DIRCHILDREN} }, $newdir );
    return;
}

sub addfile {
    my $self     = shift;
    my $filename = shift;
    my $newfile  = File->new( $filename, $self );
    push( @{ $self->{FILECHILDREN} }, $newfile );
    return;
}

sub gettotalsize {
    my $self = shift;
    return $self->{TOTALSIZE};
}

1;
