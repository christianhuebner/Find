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
        print "Starting objfind on basedir $rootdir\n";
        my $rootobj = Directory->new( $rootdir, "none" );
        print $rootobj->getitem("PATH")
          . ": size "
          . $rootobj->getitem("TOTALSIZE")
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
