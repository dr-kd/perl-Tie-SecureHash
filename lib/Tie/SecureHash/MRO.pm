package Tie::SecureHash::MRO;
use warnings;
use strict;
use Carp;
use Memoize;
use mro;
memoize('_get_mro');

sub _get_mro {
    my ($class) = @_;
    croak "_get_mro is a class method" if ref $class;
    my @isa = @{mro::get_linear_isa($class)};
    $DB::single=1;
    do {
	pop @isa;
    } until ($isa[-1] ne __PACKAGE__);
    return \@isa;
}

our ($safe, $strict, $relaxed, $fast);


sub new {
    my %self = ();
    my $class =  shift;
    $class = ref($class)||$class;
    my $blessclass =  $class;
    my $impl = tie %self, $class unless $fast;
    my $self = bless \%self, $blessclass;
    return $self;
}

sub import {
    my ($pkg, @args) = @_;
    my $args = join (' ', @args);
    $safe    = $args =~ /\bsafe\b/;
    $strict  = $args =~ /\bstrict\b/;
    $relaxed = $args =~ /\brelaxed\b/;
    $fast    = $args =~ /\bfast\b/;
    $strict  = 1 unless $safe || $strict || $relaxed;
    croak "$pkg can't be both safe and relaxed" if $safe && $relaxed;
    croak "$pkg can't be both safe and fast"    if $safe && $fast;
}

sub FETCH {
    my ($self, $key) = @_;
    my ($namespace, $keyname) = $key =~ /^(\S*::)(.*?)$/;
    $DB::single=1;
    my $entry;
    $entry = \$self->{$key};
}

sub STORE {
    my ($self, $key, $value) = @_;
    my ($namespace, $keyname) = $key =~ /^(\S*)(?=::)(.*?)$/;
    die "Illegal namespace" if $namespace && ! $self->isa($namespace);
    $namespace = ref $self if ! $namespace;
    $keyname = $key if ! $keyname;
    my $entry = $value;
    $entry = \$self->{"$namespace::$keyname"};
}

sub DELETE {
    my ($self, $key) = @_;
    my ($namespace, $keyname) = $key =~ /^(\S*::)(.*?)$/;
    $DB::single=1;
    delete $self->{$key};
}

sub CLEAR {
    my ($self) = @_;
    %$self = ();
}

sub EXISTS {
    my ($self, $key) = @_;
    my ($namespace, $keyname) = $key =~ /^(\S*::)(.*?)$/;
    $DB::single=1;
    return exists $self->{$key};
}

sub FIRSTKEY {
    my ($self) = @_;
    CORE::keys %$self;
    goto &NEXTKEY;
}

sub NEXTKEY {
    my ($self) = @_;
    return CORE::each %$self;
}

sub each($)     { CORE::each %{$_[0]} }
sub keys($)     { CORE::keys %{$_[0]} }
sub values($)   { CORE::values %{$_[0]} }
sub exists($$)  { CORE::exists $_[0]->{$_[1]} }


sub TIEHASH {
    my ($class) = @_;
    $class = ref($class) || $class;
    bless {}, $class;
}


sub DESTROY {
     # NOOP
    # (BE CAREFUL SINCE IT DOES DOUBLE DUTY FOR tie AND bless)
}

1;
