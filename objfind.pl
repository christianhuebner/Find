#!/usr/bin/perl -w

use strict;
use warnings;
use Directory;

sub main {
    my $basedir = shift || "";

    if ( -e $basedir ) {
        print "Starting objfind on basedir $basedir\n";
        my $rootobj = Directory->new($basedir, "none");
        #print $rootobj->getdata("INODE") . " ";
    }
    else {
        die "Basedir $basedir not found\n";
    }
    return;
}

&main(@ARGV);
