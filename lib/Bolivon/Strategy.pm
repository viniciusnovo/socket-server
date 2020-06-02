package Bolivon::Strategy;
use strict;
use warnings;
use feature qw(say state);
use Data::Dumper;

sub new {
    my ($class, %args) = @_;
    my $self = \%args;
    bless $self, $class;
    return $self;
}

sub validate {
    my ($self, $listenerMessage, $config, $converter, $requester) = @_;

    my $convertedXml = $converter->to_hashref($listenerMessage);
    say "Converted XML: " . Dumper($listenerMessage);

    #TO-DO Parser XML Schema

    my $effectuedSaleResult = $requester->eftectuate_sale($config->{ApiURL}, $convertedXml);
    #TO-DO Validate Return
    $requester->notify_effectuation($config->{WebHookUrl});

    return $effectuedSaleResult->{message};
}

1;