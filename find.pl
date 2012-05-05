#!/usr/bin/perl -w

use strict;
use Cwd;

sub recurse {
	my $currentdir = shift;
	my $level = shift;
	chdir $currentdir;
	my $cwd = cwd;
	print " " x $level."$level: Entering $cwd\n";

	opendir(D, '.') || die "Cannot open directory $currentdir\n";
	my @dircontent = readdir( D );
	closedir( D );

	my ($thisdirsize, $thisdirfiles) = (0, 0);
	foreach (@dircontent) {
		if($_ eq '.' || $_ eq '..') {
			next;
		} elsif( -l $_ ) {
			next;
		} elsif( -d $_ ) {
			my ($subdirsize, $subdirfiles) = &recurse( $_, $level+1 );
			$thisdirsize += $subdirsize;
			$thisdirfiles += $subdirfiles;
		} elsif( -f $_ ) {
		} else {
			next;
		}
		my $filesize = -s $_ || 0;
		$thisdirsize += $filesize; 
		$thisdirfiles ++;
	}
	print " " x $level."$level: Returning from $cwd, $thisdirfiles files total\n";
	chdir( ".." );
	return ($thisdirsize, $thisdirfiles);
}

sub main {
	my $basedir = shift || "";
	print "Basedir: $basedir\n";
	if (-e $basedir) {
		(my $size, my $files) = &recurse( $basedir, 0 );
		my $fs = -s $basedir;
		print "$basedir $fs\n";
		$files ++;                                        # Account for the base directory
		print "$basedir: $size bytes, $files files\n";
	} else {
		die "Basedir not found\n";
	}
}

&main(@ARGV);
