#!/usr/bin/perl

use strict;
use warnings;

use Smart::Comments;
use FindBin;
use lib "$FindBin::Bin/../src";
use Database;
use LekanUtils;

my $dbh = connect_database();

my $id = get_max_source_id( $dbh );

### $id


sub get_max_source_id {
    my $dbh = shift;

    my $sql = qq{select max(sourceId) from worker};
    my $task = $dbh->selectrow_array( $sql );

    return $task;
}
