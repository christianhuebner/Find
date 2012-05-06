package Directory;

use strict;
use warnings;
use feature "switch";    # Allow Perl 5.10+ given/when statement

use Node;
use base qw(Node);       # Inherit from class Node
use File;

sub new {
    my $class = shift;
	my $path = shift;
	my $parent = shift || "none";
	#print "Directory $path parent $parent\n";
    my $self  = $class->SUPER::new( my $dummy, $path, $parent);
    $self->{DIRCHILDREN}  = [];
    $self->{FILECHILDREN} = [];
    $self->{LINKCHILDREN} = [];
    $self->{DIRSIZE}      = 0;
    $self->{TOTALSIZE}    = 0;
    $self->{TOTALFILES}   = 0;
    $self->{TOTALDIRS}    = 0;
    $self->{TOTALLINKS}   = 0;
    $self->populate();
	$self->collect();
    return $self;
}

sub populate {
    my $self = shift;
	#print "populating ".$self->{PATH}."\n";
    opendir( D, $self->{PATH} )
      || die "Cannot open directory " . $self->{PATH} . "\n";
    my @dircontent = readdir(D);
    closedir(D);
	
    foreach (@dircontent) {
		if(/^\.$/ || /^\.\.$/) {
			next;
		}
		my $path = $self->{PATH}."/".$_;
        given ($path) {
            when (-l) {
            }
            when (-d) {
                $self->adddir($_);
            }
            when (-f) {
                $self->addfile($_);
            }
        }
    }
    return;
}

sub collect {
	my $self = shift;
	my %stats;
	foreach( @{$self->{FILECHILDREN}} ) {
		$self->{TOTALSIZE} += $_->getsize();
	}
	foreach( @{$self->{DIRCHILDREN}} ) {
		$self->{TOTALSIZE} += $_->gettotalsize();
	}
	$self->{TOTALSIZE} += $self->{SIZE};
	print $self->{PATH}." Size: ".$self->{TOTALSIZE}."\n";
}

sub adddir {
    my $self    = shift;
    my $dirname = shift;
    my $newdir  = Directory->new( $dirname, $self );
    push( @{ $self->{DIRCHILDREN} }, $newdir );
	#print "Newdir ".$newdir->getpath()."\n";
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
