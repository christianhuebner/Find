package Node;

sub new {
	my $class = shift;
	$self = { 
		@_,			# Name, Recursion level
		DIROBJECTS => [], 
	};
	bless ($self, $class);
print "Created ".$self->{NAME}."\n";
	$self->populate();
	return $self;
}

sub populate {
	my $self = shift;

	opendir(D, $self->{NAME} ) || die "Cannot open directory ".$self->{NAME}."\n";
	my @dircontent = readdir( D );
	closedir( D );

	foreach( @dircontent ) {
		next if($_ eq '.' || $_ eq '..');
		my $childpath = $self->{NAME}."/".$_;

		if( -d $childpath ) {
			my $dirnode = Directory->new( NAME => $childpath );
			push( @{$self->{DIROBJECTS}}, $dirnode );
		}
	}
	print $self->{NAME}." ".@{$self->{DIROBJECTS}}."\n";
}

sub check {
	my $self = shift;
	print "Checking: ".$self->{NAME}." Dirobjects: ".@{$self->{DIROBJECTS}}."\n";

	foreach( @{$self->{DIROBJECTS}} ) {
		print $_->getname();
	}
}

sub getname {
	my $self = shift;
	return $self->{NAME};
}

1;
