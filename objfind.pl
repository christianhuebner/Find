#!/usr/bin/perl -w
#===============================================================================
#
#         FILE: objfind.pl
#
#  DESCRIPTION: Uses Directory.pm class to build and search a file tree
#
#       AUTHOR: Christian Huebner <christian.huebner@linuxwisdom.com>
# ORGANIZATION: LinuxWisdom, Inc.
#      CREATED: 05/06/2012
#     REVISION: 
#===============================================================================

use strict;
use warnings;

use Directory;
use Cwd;

sub main {
    my $basedir = shift || "";
	
    if ( chdir($basedir) ) {
		my $rootdir = cwd(); # Fastest way to get an absolute path to the directory
        my $rootobj = Directory->new( $rootdir, "none" );
		my $totalitems = $rootobj->getitem("TOTALDIRS")+$rootobj->getitem("TOTALFILES")+$rootobj->getitem("TOTALLINKS");
        print "objfind.pl: "
		  . $rootobj->getitem("PATH")
          . ": size "
          . $rootobj->getitem("TOTALSIZE")
		  . " total items "
		  . $totalitems
          . " dirs "
          . $rootobj->getitem("TOTALDIRS")
          . " files "
          . $rootobj->getitem("TOTALFILES")
          . " links "
          . $rootobj->getitem("TOTALLINKS") . "\n";
    }
    else {
        die "Basedir $basedir not found\n";
    }
    return;
}

main(@ARGV);
