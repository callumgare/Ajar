use strict;
use warnings;
use Test::More;

use_ok('Game::Ajar::Hashes');
use_ok('Game::Ajar::OtherHashes');
use_ok('Game::Ajar::Subs');
use_ok('Game::Ajar::Actions');
use_ok('Game::Ajar::Commands');
use_ok('Game::Ajar::Combine');
use_ok('Game::Ajar::Combine::IfTree');
use_ok('Game::Ajar::Look::IfTree');
use_ok('Game::Ajar::Reach');
use_ok('Game::Ajar::Reach::IfTree');
use_ok('Game::Ajar::Separate');
use_ok('Game::Ajar::Separate::IfTree');
use_ok('Game::Ajar::Use');
use_ok('Game::Ajar::Use::Actions');
use_ok('Game::Ajar::Use::IfTree');

isnt($Game::Ajar::M{dir}, undef, 'Have a sharedir');

diag( "Testing Protal $Protal::VERSION, Perl $], $^X" );

done_testing;
