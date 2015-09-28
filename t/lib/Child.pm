package Child;
use parent 'Jack';
use Class::Method::Modifiers;
after new => sub {
    my ($self) = @_;
    $self->{_inheritance} = '$10';
    $self->{__secrets_to_the_grave} = "I'm a person";
    $self->{name} = 'Baby';
};

1;
