package Bolivon::Requester;
use strict;
use warnings;
use feature qw(say state);
use JSON;
use HTTP::Request;
use LWP::UserAgent;
use Data::Dumper;

sub new {
    my ($class, %args) = @_;
    my $self = \%args;
    bless $self, $class;
    return $self;
}

sub eftectuate_sale {
    my ($self, $url, $body) = @_;

    my $request = HTTP::Request->new(POST => $url);
    $request->header('Content-Type' => 'application/json');

    my $jsonBody = encode_json($body);
    $request->content($jsonBody);

    my $ua = LWP::UserAgent->new();
    my $response = $ua->request($request);

    my $hashResposta = decode_json($response->decoded_content);
    say "------> Response: " . Dumper($hashResposta);

    return $hashResposta;
}

sub notify_effectuation {
    my ($self, $url) = @_;

    my $request = HTTP::Request->new(POST => $url);
    $request->header('Content-Type' => 'application/json');

    my $ua = LWP::UserAgent->new();
    my $response = $ua->request($request);
    say "------> Response: " . Dumper($response);
}

1;