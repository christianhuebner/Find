#!/usr/bin/perl -W

use strict;

sub recurse {
	my $currentdir = shift;

	my ($thisdirsize, $thisdirfilecount) = (0, 0);
print "Currentdir: $currentdir\n";
	opendir(D, $currentdir) || die "Cannot open directory $currentdir\n";
	my @dircontent = readdir( D );
	closedir( D );
print "$currentdir contains ".@dircontent." files\n";

	foreach (sort @dircontent) {
		print "$_";
		if( -d ) { 
			print "/";
		} elsif( -x ) {
			print "*";
		}
		print " ";
	}
	print "\n";
	foreach (@dircontent) {
		if($_ eq '.' || $_ eq '..') {
			# do nothing
		} elsif( -d $_ ) {
		print "2: $_\n";
			my $subdirsize = &recurse( $_ );
			print "$_: $subdirsize\n";
			$thisdirsize += $subdirsize;
		} elsif( -f $_ ) {
		print "3: $_\n";
			my $filesize = -s $_;
			$thisdirsize += $filesize; 
			print "$_ $filesize $thisdirsize\n";	
		}
	}
	return $thisdirsize;
}

sub main {
	my $basedir = shift || "";
	print "Basedir: $basedir\n";
	if (-e $basedir) {
		print "$basedir: ".&recurse($basedir)."\n";
	} else {
		die "Basedir not found\n";
	}
}

&main(@ARGV);
