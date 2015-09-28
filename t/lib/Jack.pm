package Jack;
use parent 'Grandparent';
use Class::Method::Modifiers;
after new => sub {
    my ($self) = @_;
    $self->{_inheritance} = '$50';
    $self->{__secrets_to_the_grave} = "I'm a goat";
    $self->{name} = 'Jack';
};
1;
