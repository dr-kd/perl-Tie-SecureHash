package Grandparent;
use parent 'Tie::SecureHash::MRO';
use Class::Method::Modifiers;
sub setup {
    my ($self) = @_;
    $self->{_inheritance} = '$100';
    $self->{__secrets_to_the_grave} = "I'm a duck";
    $self->{name} = 'Bill';
}
1;
