package Bolivon::SocketServer;
use strict;
use warnings;
use threads;
use IO::Socket::INET;
use Data::Dumper;
use feature qw(say state);

use FindBin;
use lib "$FindBin::Bin/lib";

use Bolivon::Converter;
use Bolivon::Requester;
use Bolivon::Strategy;

state $converter = Bolivon::Converter->new();
state $requester = Bolivon::Requester->new();
state $strategy = Bolivon::Strategy->new();

$| ++;

sub new {
    my ($class, %args) = @_;
    my $self = \%args;
    bless $self, $class;
    return $self;
}

sub run {
    my ($self) = @_;
    say Dumper($self->{Config});
    say "API URL: " . $self->{Config}->[0]->{ApiURL};
    my $listener = IO::Socket::INET->new(
        LocalPort => $self->{Config}->[0]->{ListenPort},
        Listen => 5,
        Reuse => 1) ||
        die "Cannot create socket\n";

    my $client;
    my $client_num = 0;

    $client = $listener->accept;
    threads->create(\&__start_thread, $client, ++ $client_num, $self->{Config}->[0]);
}

sub __start_thread {
    threads->self->detach();
    my ($client, $client_num, $config) = @_;
    print "Thread created for client $client_num\n";
    while (1) {
        my $whole_req = "";
        do {
            my $req;
            $client->recv($req, 700000);
            return if ($req eq "");
            $whole_req = $whole_req . $req;
        } until ($whole_req =~ m/\r\n\r\n/x);

        print "Client $client_num got req:\n$whole_req";

        my $convertedXml = $converter->to_hashref($whole_req);
        say "Converted XML: " . Dumper($convertedXml);

        my $strategyResult = $strategy->validate($whole_req, $config, $converter, $requester);
        say $strategyResult;
    }
    return;
}

1;