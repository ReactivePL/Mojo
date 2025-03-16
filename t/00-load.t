#!perl
use 5.006;
use strict;
use warnings;
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'Reactive::Mojo' ) || print "Bail out!\n";
}

diag( "Testing Reactive::Mojo $Reactive::Mojo::VERSION, Perl $], $^X" );
