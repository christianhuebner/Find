package Node;

# Superclass for directory, file, link

sub new {
	my $class = shift;
	$self = { 
		PATH => $_[1],
		PARENT => undef,
		DEV => undef,
		SIZE => 0,
		CTIME => 0,
		MTIME => 0,
		ATIME => 0,
		PERMISSIONS => undef
	};
	bless ($self, $class);
	$self->populate();
	return $self;
}

sub populate {
	my $self = shift;
	my @statkeys = qw(DEVICE INODE MODE NLINK UID GID RDEV SIZE ATIME MTIME CTIME BLKSIZE BLOCKS);
	@{$self}{@statkeys} = stat( $self->{PATH} );
	print $self->{"SIZE"}."\n";
	return ;
} ## --- end sub populate

sub getname {
	my $self = shift;
	return $self->{NAME};
}

1;
