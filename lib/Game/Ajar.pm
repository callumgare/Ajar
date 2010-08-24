#!/usr/bin/env perl
package Game::Ajar;
use 5.010;
our $VERSION = 0.001;
unless($^O eq "MSWin32" and $ARGV[0] ne "-winexe") { #don't if running from windows without exe
	$SIG{INT} = "sigint"; #disable Ctrl+C
	sub sigint{}
}

use File::Share::Dir();

our (%M, %H) = (
	state => {
		player => 0,
		action_count  => 0,
		character_count => 0,
	},
	msgnum => {},
	dir => File::Share::Dir::dist_dir("Game-Ajar");
);

package main;

use Game::Ajar::Hashes;
use Game::Ajar::OtherHashes;
use Game::Ajar::Subs;
use Game::Ajar::Actions;
use Game::Ajar::Commands;
use Game::Ajar::Combine;
use Game::Ajar::Combine::IfTree;
use Game::Ajar::Look::IfTree;
use Game::Ajar::Reach;
use Game::Ajar::Reach::IfTree;
use Game::Ajar::Separate;
use Game::Ajar::Separate::IfTree;
use Game::Ajar::Use;
use Game::Ajar::Use::Actions;
use Game::Ajar::Use::IfTree;

clear_0();

if($^O eq "MSWin32") { #Colour and sound for Windows
	eval {
		require Win32::Console::ANSI;
		require Win32::Sound;
	};
	if($@) { #Missing module(s)
		print "Win32::Console::ANSI and Win32::Sound must be installed to play Ajar on
Windows.";
		exit;
	}
}

#This Ajar ASCII title is a combination of Big and Slant fonts from www.network-science.de/ascii/
#If you can make a better one, I would love you for it :-)
print "\n$c{bg}$c{t2}\t\t\t    _________________________
\t\t\t   |\\$c{t1}         _             $c{t2}/|
\t\t\t   |$c{t1}      ___(_)             $c{t2}|
\t\t\t   |$c{t1}     /   | | __ _ ____   $c{t2}|
\t\t\t   |$c{t1}    / /| | |/ _` |  __|  $c{t2}|
\t\t\t   |$c{t1}   / ___ | | (_| | |     $c{t2}|
\t\t\t   |$c{t1}  /_/  |_| |\\__,_|_|     $c{t2}|
\t\t\t   |$c{t1}        _/ |             $c{t2}|
\t\t\t   |$c{t1}       |__/              $c{t2}|
\t\t\t   |/_______________________\\|\n\n\n";

if(-e "save/alias.sav") {
	open ALIAS, "save/alias.sav" or print "$c{e}Could not open alias file\n";
	while(<ALIAS>) {
		chomp;
		if($_) {
			my ($key, $list) = split "\t", $_;
			if($start_actions_0{$key} or $start_actions_1{$key} or $lock_actions_0{$key} or $lock_actions_1{$key} or $commands{$key}) {
				$alias{$key} = $list;
			}
			else {
				print "$c{e}Alias file has been tampered with: \"$key\"\n";
				last;
			}
		}
	}
	close ALIAS;
}
$alias{"title!"} = %alias ? "Aliases:" : "There are no aliases set.";

if(&saved_games()) {
	print "$c{w}Welcome.\n$c{ooc} Q: Would you like to load a saved game?\n";
	if(&yes()) { &load(); } 
	else {
		print "\n$c{w}Remember, \"$c{av}help$c{w}\" brings up the help section.\n";
	}
}
else {
	print "$c{w}Welcome. This may be your first time playing as you have no games saved.\n\"$c{av}help$c{w}\" brings up the help section.\n";
}
print "\n"; #an extra newline feels good

while(1) {
	print "\n$c{l}>$c{av}";
	my ($action, @args) = &break_input();

	if(!$actions{$action} and !$commands{$action}) {
		for my $key (grep $_ ne "title!", keys %alias) {
			if(grep $action eq $_, split ", ", $alias{$key}) {
				$action = $key;
				last;
			}
		}
	}
	$actions{$action} and $state{actioncount}++;

	if(@args) {
		if($actions_1{$action} or $commands_1{$action}) {
			&{$action}(@args);
		}
		elsif($actions_0{$action} or $commands_0{$action}) {
			print "$c{e}Ignoring unnecessary values for $action.\n";
			undef @args;
		}
		else { undef @args; }
	}
	if(!@args) {
		if($actions_0{$action} or $commands_0{$action}) {
			exists &{$action."_0"} ? &{$action."_0"}()
			: &print_list($action);
		}
		elsif($actions_1{$action} or $commands_1{$action}) {
			&{$action}();
		}
		else {
			print "$c{e}Unknown Action or Command: \"$action\"";
		}
	}
}

END { #last thing Ajar does before exit
	if($? == 1337) { #new game status
		$? = 0; #we're actually exiting normally
	}
	elsif($^O eq "MSWin32") {
		system "color"; #reset color to user's default
	}
	else {
		print "\e[0m"; #likewise
	}
}