package Bolivon::Converter;
use strict;
use warnings;
use XML::Hash;
use feature qw(say);

sub new {
    my ($class, %args) = @_;
    my $self = \%args;
    bless $self, $class;
    return $self;
}

sub to_hashref {
    my ($self, $xmlString) = @_;
    my $xml_converter = XML::Hash->new();

    return $xml_converter->fromXMLStringtoHash($xmlString);
}

1;