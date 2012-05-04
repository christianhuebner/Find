#!/usr/bin/perl -W

use strict;

sub recurse {

}

sub main {
	my $basedir = shift | "";
	&recurse($basedir);
}

&main(@ARGV);
