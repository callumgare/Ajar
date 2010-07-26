#!/usr/bin/env perl
use 5.010;
use strict;
use Text::Wrap qw($columns $unexpand $tabstop);
($columns, $unexpand, $tabstop) = (80, 0, 4);
unless($^O eq "MSWin32" and $ARGV[0] ne "-winexe") { #don't if running from windows without exe
	$SIG{INT} = "sigint"; #disable Ctrl+C
	sub sigint{}
}

our (%M, %H) = (
	state => {
		player => 0,
		action_count  => 0,
		character_count => 0,
	},
	msgnum => {},
);
chdir "source" or die "Ajar/source: $!";
require while <data/*.ph>; # .ph first
require while <data/*.pl>; # then .pl

clear_0();

if($^O eq "MSWin32") { #Colour and sound for Windows
	eval {
		require Win32::Console::ANSI;
		require Win32::Sound;
	};
	if($@) { #Missing module(s)
		if(($make) = `perl -V:make` =~ /make='(.*)'/) {
			print "The modules for colour and/or sound don't seem to be installed.\n Q: Do you want to install them now with \"$make\"?\n";
			if(yes("no_color")) {
				print "\nPlease wait while the modules install . . .\n";
				chdir "bin/Win32/Console-ANSI-1.04" or die "Ajar/source/bin/Win32/Console-ANSI-1.04: $!";
				system "perl Makefile.PL";
				system "$make";
				system "$make install";
				require Win32::Console::ANSI;
				chdir "../Sound-0.49" or die "Ajar/source/bin/Win32/Sound-0.49: $!";
				system "perl Makefile.PL";
				system "$make";
				system "$make install";
				require Win32::Sound;
				chdir "../../.." or die "Ajar/source: $!";
				print "\nModules installed successfully!\n"; #no death, so successful
				system "pause && cls";
			}
			else {
				print "
Win32::Console::ANSI and Win32::Sound must be installed to play Ajar on
Windows. They are located in Ajar/source/bin/Win32 if you want to install them
manually. Check www.cpan.org for help on doing this. Otherwise, simply restart
Ajar and let it try to do it for you. If you are having problems, remove any
other Perls you may have and cleanly install Strawberry Perl v5
(www.strawberryperl.com) before contacting me.";
				exit;
			}
		}
		else {
			print "
Win32::Console::ANSI and Win32::Sound must be installed to play Ajar on
Windows. Seeing as you do not have a make program, Ajar cannot do it for you.
They are located in Ajar/source/bin/Win32 if you want to install them manually.
Check www.cpan.org or your Perl's documentation for help on doing this.
However, I urge you to remove whatever Perl you have installed, install
Strawberry Perl v5 (www.strawberryperl.com), and let Ajar do it for you.";
			exit;
		}
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