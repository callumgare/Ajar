#!perl -T
use strict;
use Test::More;

use_ok('Protal');
use_ok('Protal::Editor');
use_ok('Protal::Inc');
use_ok('Protal::MakeChamber');
use_ok('Protal::Player');
use_ok('Protal::SDLChanges');

isnt($Protal::M{dir}, undef, 'Have a sharedir');

diag( "Testing Protal $Protal::VERSION, Perl $], $^X" );

done_testing;
