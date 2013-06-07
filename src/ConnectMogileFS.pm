package ConnectMogileFS;

use strict;
use warnings;

use Smart::Comments;

use YAML;
use DBI;
use MogileFS::Client;

use FindBin;

use base qw(Exporter);

our $VERSION = '0.01';
our @EXPORT = qw(connect_mogilefs connect_db);
our @EXPORT_OK = qw();

sub connect_mogilefs {
    my $config_file = join '/', $FindBin::Bin, '..', 'etc', 'ctscfg.yaml';
    my $options = YAML::LoadFile( $config_file );
    
    my $domain = $options->{trackers}->{domain};
    my $hosts  = join ':', @{$options->{trackers}}{'host','port'};

    my $mogc = MogileFS::Client->new(  domain => $domain,
                                       hosts  => [ $hosts ]
                                   )
        or die "Can't connect $hosts: $!";

    return $mogc;
}

sub connect_db {
    my $config_file = join '/', $FindBin::Bin, '..', 'etc', 'ctscfg.yaml';
    my $options = YAML::LoadFile( $config_file );
    
    my $dbinfo = $options->{mogdatabase};

    my $dbhost = $dbinfo->{ip};
    my $dbport = $dbinfo->{port};
    my $dbuser = $dbinfo->{user};
    my $dbpass = $dbinfo->{passwd};
    my $dbname = $dbinfo->{dbname};

    my $db     = "DBI:mysql:$dbname;host=$dbhost";
    my $dbh    = DBI->connect( $db, $dbuser, $dbpass,
                               {
                                   RaiseError => 1,
                               }
                           ) or die "Can't connect db: $DBI::errstr\n";

    return $dbh;
}

1;

