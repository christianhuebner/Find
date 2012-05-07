#!/usr/bin/perl -w
#
#===============================================================================
#
#         FILE: find.pl
#
#  DESCRIPTION: 
#
#       AUTHOR: Christian Huebner (), <christian.huebner@linuxwisdom.com>
# ORGANIZATION: LinuxWisdom, Inc.
#      CREATED: 05/07/2012
#     REVISION: ---
#===============================================================================

use warnings;
use strict;

use feature "switch";

use Cwd;

sub recurse {
    my $currentdir = shift;
    my $level      = shift;
    chdir $currentdir;
    my $cwd = cwd;

    opendir( D, "." ) || die "Cannot open directory $currentdir\n";
    my @dircontent = readdir(D);
    closedir(D);

    my ( $thisdirsize, $thisdirfiles ) = ( 0, 0 );
    foreach my $dir (@dircontent) {
        given ($dir) {
        	when ( ( $dir =~m/^\.$/x) || ( $dir =~ m/^\.\.$/x ) ) { next; }
			when ( -l ) {
				my $filesize = length(readlink( $dir ));
				print "$dir $filesize\n";
		        $thisdirsize += $filesize;
        		$thisdirfiles++;
				next;
			}
            when ( -d ) {
                my ( $subdirsize, $subdirfiles ) = &recurse( $_, $level + 1 );
                $thisdirsize  += $subdirsize;
                $thisdirfiles += $subdirfiles;
            }
        }
        my $filesize = -s $dir || 0;
        $thisdirsize += $filesize;
        $thisdirfiles++;
    }
    chdir ( ".." );
    return ( $thisdirsize, $thisdirfiles );
}

sub main {
    my $basedir = shift || "";
    print "Basedir: $basedir\n";
    if ( -e $basedir ) {
        my ( $size, $files ) = &recurse( $basedir, 0 );
		$size += -s $basedir;	#Account for basedir size
        $files++;    			# Account for the base directory
        print "$basedir: $size bytes, $files files\n";
    }
    else {
        die "Basedir not found\n";
    }
    return;
}

&main(@ARGV);
