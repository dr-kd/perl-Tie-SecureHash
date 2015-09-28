package Descendent;
use parent 'Grandchild';
use Class::Method::Modifiers;
after new => sub {
    my ($self) = @_;
    $self->{_inheritance} = '$0';
    $self->{__secrets_to_the_grave} = "I'm not here yet";
    $self->{name} = 'Dunno';
};

1;
