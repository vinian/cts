#!/usr/bin/perl

use strict;
use warnings;

use Smart::Comments;
use File::Basename;
use File::Copy;
use File::Path;
use POSIX;

use FindBin;
use lib $FindBin::Bin;
use Database;
use LekanUtils;
use LekanConfig;
use DeleteFile;


our $VERSION = '0.01';

my $job = worker();
### $job

sub worker {
    my $task = fetch_task();

    return $task;
}

sub fetch_task {
    my $dbh = connect_database();
    
    my $task;
    for my $index ( reverse 0..5 ) {
        my $sql = qq{SELECT * FROM worker where status=0 and priority=$index ORDER BY sourceId LIMIT 1};
        $task = $dbh->selectrow_hashref( $sql );
        ### 'fetch_task': $task
        last if defined $task;
    }

    return if not defined $task;

    if ( $task->{type} eq 'twopass' ) {
        my $can_run = judge_task( $task->{sourceId} );
        ### $can_run
        if ( not $can_run ) {
            $task = select_job( $task->{sourceId} );
        }
    }

    $dbh->disconnect;
    return $task;
}

sub judge_task {
    my $sourceId = shift;

    my $dbh = connect_database();

    my $sql = qq{SELECT * FROM worker where status=2 and sourceId=$sourceId and type='onepass'};
    ### $sql
    my $data = $dbh->selectrow_hashref( $sql );

    my $flag = 0;
    if ( defined $data ) {
        $flag = 1;
    }

    return $flag;
}

sub select_job {
    my $sId = shift;
    my $task;

    my $dbh = connect_database();
    for my $index ( reverse 0..5 ) {
        my $sql = qq{SELECT * FROM worker where status=0 and priority=$index and type='onepass' ORDER BY sourceId LIMIT 1};
        runlog(__PACKAGE__, 'select_job', $sql);
        $task = $dbh->selectrow_hashref( $sql );
        last if defined $task;
    }

    if (not defined $task) {
        my $i = 0;
        # 有可能某个 ID 的任务不能执行，然后后面的就不行执行了
        while ( $i ++ < 20 ) {
            for my $index ( reverse 0..5 ) {
                my $sql = qq{SELECT * FROM worker where status=0 and priority=$index and sourceId>$sId ORDER BY sourceId LIMIT 1};
                ### $sql
                $task = $dbh->selectrow_hashref( $sql );
                if ( defined $task ) {
                    my $flag = judge_task( $task->{sourceId} );
                    last if $flag;
                }
            }
            $sId ++;
        }
    }

    ### 'select_job': $task    
    $dbh->disconnect;
    return $task;
}
