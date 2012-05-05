package Directory;

use Cwd;

sub new {
	my $class = shift;
	$self = { 
		@_,
		FILES => 0, 
		LINKS => 0, 
		DIRS => 0, 
		DIRCHILDREN => [], 
		DIROBJECTS => [], 
		SIZE => 0, 
		SPECIAL => 0
	};
	bless ($self, $class);
	chdir( $self->{NAME} );
	$self->populate();
	$self->recurse();
	$self->collect();
	my $cwd = cwd();
	print "Leaving $cwd\n";
	chdir( ".." );
	$cwd = cwd();
	print " to $cwd\n";
	return $self;
}

sub populate {
	my $self = shift;

	opendir(D, '.') || die "Cannot open directory ".$self->{NAME}."\n";
	my @dircontent = readdir( D );
	closedir( D );
	my $cwd = cwd();
	print "Populating $cwd\n";
	
	foreach( @dircontent ) {
		if($_ eq '.' || $_ eq '..') {
			next;
		} elsif( -l ) {
			$self->{LINKS}++;
			next;
		} elsif( -d ) {
			$self->{DIRS}++;
			$self->{THISDIRSIZE} += -s $_;
			push @{$self->{DIRCHILDREN}}, $_;
		} elsif( -f ) {
			$self->{FILES}++;
			$self->{THISDIRSIZE} += -s $_;
		} else {
			$self->{SPECIAL}++;
			next;
		}
	}
}

sub recurse {
	my $self = shift;	
	foreach ( @{$self->{DIRCHILDREN}} ) {
		print "Recursing into: $_\n";
		my $dirobj = Directory->new( NAME => $_);
		#$dirobj->populate();
		#$dirobj->recurse();
		#$dirobj->collect();
		$dirobj->print();
		push @{$self->{DIROBJECTS}}, $dirobj;
	}	
}

sub collect {
	my $self = shift;
	foreach( @{$self->{DIROBJECTS}} ) {
		$self->{FILES} += $_->getfiles();;
	}
}

sub getfiles {
	my $self = shift;
	return $self->{FILES};
}

sub print {
	my $self = shift;
	print "Search Directory: $self->{NAME}\n";
	print "Files: $self->{FILES}\n";
	print "Directories: $self->{DIRS}\n";
	print "Links: $self->{LINKS}\n";
	print "Size: $self->{SIZE}\n";
}

1;
