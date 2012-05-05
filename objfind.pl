#!/usr/bin/perl -w

use strict;
use Directory;

sub main {
	my $basedir = shift || "";

	if (-e $basedir) {
		print "Starting objfind on basedir $basedir\n";
		my $baseobj = Directory->new( NAME => $basedir );
		$baseobj->print();
	} else {
		die "Basedir $basedir not found\n";
	}
}

&main(@ARGV);
