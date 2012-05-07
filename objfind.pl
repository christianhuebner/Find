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
#     REVISION: 0.8
#===============================================================================

use strict;
use warnings;
use Directory;

sub main {
    my $basedir = shift || "";

    if ( -e $basedir ) {
        print "Starting objfind on basedir $basedir\n";
        my $rootobj = Directory->new($basedir, "none");
        print $rootobj->getitem("TOTALSIZE")."\n";
    }
    else {
        die "Basedir $basedir not found\n";
    }
    return;
}

&main(@ARGV);
