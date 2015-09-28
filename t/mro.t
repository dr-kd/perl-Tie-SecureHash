#!/usr/bin/env perl
use warnings;
use strict;
use Data::Dumper;
use FindBin qw/$Bin/;
use lib "$Bin/lib";

use Grandparent; 
use Jack; 
use Child; 
use Grandchild; 
use Descendent;
use Test::More;

my $gp = Grandparent->new();
my $p  = Jack->new();
my $c  = Child->new();
my $gc = Grandchild->new();
my $d  = Descendent->new();
$gp->setup;
diag "Grandparent";

diag "Jack";

diag "Child";

diag "Grandchild";

diag "Descendent";

ok(1);
done_testing;
