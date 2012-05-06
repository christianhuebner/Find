#!/usr/bin/perl -w

use strict;
use Node;

sub main {
	my $basedir = shift || "";

	if (-e $basedir) {
		print "Starting objfind on basedir $basedir\n";
		my $baseobj = Node->new( PATH => $basedir );
		#$baseobj->dirstats();
		#$baseobj->print();
	} else {
		die "Basedir $basedir not found\n";
	}
}

&main(@ARGV);
