#!/usr/bin/perl

use strict;
use warnings;

use Smart::Comments;
use FindBin;
use lib "$FindBin::Bin/../src";

use DvdDeinterlace;
use Database;


my $source = shift;

die if not defined $source;

my $fps = get_video_fps( $source );

my $info = {
    source   => $source,
    fps      => $fps,
    out_name => "video-4000k.mp4",
};

my $ret = deinterlace( $info );
### $ret
