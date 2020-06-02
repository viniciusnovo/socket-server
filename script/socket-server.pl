#!/usr/bin/perl
use strict;
use warnings;
use warnings;
use feature qw(say);
use Data::Dumper;
use YAML::Tiny;


use FindBin;
use lib "$FindBin::Bin/../lib";

use Bolivon::SocketServer;

my $config = YAML::Tiny->read( "$FindBin::Bin/../var/config.yml" );

my $socketServer = Bolivon::SocketServer->new(Config => $config);

while (1) {
    $socketServer->run();
}
