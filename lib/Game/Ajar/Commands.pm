#!/usr/bin/perl
use warnings;

### COMMANDS ###

sub alias {
	my (@arg, @arr, @others);
	($arr[0], $arr[1], @others) = @_;
	for(@arr) {
		if($_) {
			if(s/ .+//) {
				print "$c{e}One word allowed only, shortened to \"$_\"\n";
			}
			push @arg, $_,
		}
	}
	if(!$arg[1]) { $arg[1] = ""; }
	if(@others) {
		print "$c{e}First two values excepted only.\n";
	}
	if(!@_) {
		&print_list("alias");
		return;
	}
	elsif(!$arg[1] or $arg[1] eq "!") {
		my $key;
		FAIL: {
			my @list;
			for(keys %alias) {
				$key = $_;
				@list = split ", ", $alias{$key};
				for(0..@list-1) {
					if($arg[0] eq $list[$_]) {
						splice @list, $_, 1;
						$alias{$key} = join ", ", @list;
						if(!$alias{$key}) {
							delete $alias{$key};
						}
						last FAIL;
					}
				}
			}
			if(!$arg[1]) {
				print "$c{e}\"$arg[0]\" hasn't been set. Cannot un-alias it\n";
			}
			return;
		}
		print "$c{ooc}\"$arg[0]\" has been un-aliased from \"$key\".\n";
	}
	else {
		if($actions{$arg[1]} or $commands{$arg[1]}) {
			if($actions{$arg[0]} or $commands{$arg[0]}) {
				print "$c{e}Both \"$arg[0]\" and \"$arg[1]\" are existing Actions/Commands.\n";
				return;
			}
			@arg = reverse @arg;
		}
		elsif(!$actions{$arg[0]} and !$commands{$arg[0]}) {
			print "$c{e}Neither \"$arg[0]\" or \"$arg[1]\" are existing Actions/Commands.\n";
			return;
		}

		&alias($arg[1],"!"); #call this function to un-alias it

		if($alias{$arg[0]}) {
			$alias{$arg[0]} .= ", $arg[1]";
		}
		else {
			$alias{$arg[0]} .= $arg[1];
		}
	}
	delete $alias{"title!"};
	if(%alias) { $alias{"title!"} = "Aliases:"; }
	else { $alias{"title!"} = "There are no aliases set."; }

	if(!-d "save") {
		mkdir "save", 0755 or print "$c{e}Could not create save directory for alias\n" and return;
	}
	open ALIAS, ">save/alias.sav" or print "$c{e}Could not write to alias file\n" and return;
	for(keys %alias) {
		print ALIAS "$_\t$alias{$_}\n" if $_ ne "title!";
	}
	close ALIAS;
	if($arg[1] and $arg[1] ne "!") {
		print "$c{ooc}\"$arg[1]\" is now an alias for \"$arg[0]\".\n";
	}
}

sub clear_0 {
	if($^O eq "MSWin32") {
		system "cls";
	}
	else {
		system "clear";
	}
}package Action::pah; sub clear {} package main;

sub delete {
	my ($num, @others) = @_;
	if(@others) {
		print "$c{e}Deleting only the first value\n";
	}
	if(defined $num) {
		if($num =~ /[1-9]/) {
			if(-e "save/save$num.sav") {
			print " $c{ooc}Q: Are you sure you want to delete save $num?\n";
				if(&yes()) {
					if(unlink "save/save$num.sav") { print "$c{t}Deleted save $num!\n"; }
					else { print "$c{e}Could not delete save $num\n"; }
					return;
				}
			}
			else { print "$c{e}Save $num does not exist\n"; }
		}
		else { print "$c{e}That is not a slot number from 1 to 9\n"; }
	}
	elsif(&saved_games()) {
		print "$c{t}Your Saved Games\n$c{sav}", &saved_games();
		print " $c{ooc}Q: Delete which save?\n A: ";
		my @args = split ",", &bite(scalar <STDIN>);
		if(defined $args[0]) {
			&delete(@args);
		}
		else {
			&delete("");
		}
		return;
	}
	else {
		print "$c{e}No saved games to delete\n";
		return;
	}
	print " $c{ooc}Q: Try deleting again?\n";
	if(&yes()) {
		undef @_;
		&delete();
	}
}

sub exit_0 {
	if($actions_1{look} or $msgnum{look}) { #made any progress
		print " $c{ooc}Q: Any unsaved progress will be lost, are you sure?\n";
		&yes() or return;
	}
	exit;
}

sub help {
	my ($arg, @others) = @_;
	if(@others) {
		print "$c{e}Listing help for first value only\n";
	}
	if(!@_) { &print_list("help"); }
	elsif($actions{$arg} or $commands{$arg}) {
		print "$c{ooc}$actionhelp{$arg}\n";
	}
	else {
		print "$c{e}Unknown Action or Command: \"$arg\"\n";
	}
}

sub load {
	my ($num, @others) = @_;
	RETRY:{
		if(defined $num) {
			if($num =~ /[1-9]/) {
				if(@others) {
					print "$c{e}Loading only the first value\n";
				}
				if(-e "save/save$num.sav") {
					if(-s _) {
						if(open LOAD, "save/save$num.sav") {
							if($actions_1{look} or $msgnum{look}) { #made any progress
								print " $c{ooc}Q: Any unsaved progress will be lost, are you sure?\n";
								if(!&yes()) {
									close LOAD;
									return;
								}
							}
							my ($hash, @parts);
							while(<LOAD>) {
								chomp $_;
								($hash, @parts) = split "\t", $_;
								if($hash eq 'msgnum') {
									%msgnum = (@parts);
								}
								elsif($hash eq 'state') {
									%state = (@parts);
								}
								elsif(%{"lock_$hash"}) {
									%{$hash} = %{"start_$hash"}; #back to default
									for(@parts) {
										if(${"lock_$hash"}{$_}) {
											my $key = $_;
											s/\d+$//;
											${$hash}{$_} = ${"lock_$hash"}{$key}; #
										}
										elsif(s/^no_//) {
											delete ${$hash}{$_};
										}
										else {
											print "$c{e}Loading failed. Save $num is invalid \"$hash\">\"$_\"\n";
											last RETRY;
										}
									}
								}
								else {
									print "$c{e}Loading failed. Save $num is invalid \"$hash\"\n";
									last RETRY;
								}
							}
							%actions = ("title!" => "Actions", %actions_0, %actions_1);
							print "$c{s}Loaded save $num successfully!\n";
							close LOAD;
							return;
						}
						else { print "$c{e}Could not open save/save$num.sav\n"; }
					}
					else { print "$c{e}Loading failed. Save $num is empty\n"; }
				}
				else { print "$c{e}Save $num does not exist\n"; }
			}
			else { print "$c{e}That is not a slot number from 1 to 9\n"; }
		}
		elsif(&saved_games()) {
			print "$c{t}Your Saved Games\n$c{sav}", &saved_games();
			print " $c{ooc}Q: Which save?\n A: ";
			my @args = split ",", &bite(scalar <STDIN>);
			if(defined $args[0]) {
				&load(@args);
			}
			else {
				&load("");
			}
			return;
		}
		else {
			print "$c{e}No saved games to load\n";
			return;
		}
	}
	close LOAD;
	print " $c{ooc}Q: Try loading again?\n";
	if(&yes()) {
		&load();
	}
}

sub new_0 {
	if($actions_1{look} or $msgnum{look}) { #made any progress
		print " $c{ooc}Q: Any unsaved progress will be lost, are you sure?\n";
		&yes() or return;
	}
	if($^O eq "MSWin32" and defined $ARGV[0] and $ARGV[0] eq "-winexe") {
		system "perl ajar.plx -winexe";
	}
	else {
		system "perl ajar.plx";
	}
	exit 1337;
}

sub save {
	my ($num, @others) = @_;
	{
		if(defined $num) {
			if($num =~ /[1-9]/) {
				if(@others) {
					print "$c{e}Saving only the first value\n";
				}
				if(!-d "save") {
					mkdir "save", 0755 or print "$c{e}Could not create save directory\n" and return;
				}
				if(-s "save/save$num.sav") {
					print " $c{ooc}Q: Save $num exists. Overwrite it?\n";
					&yes() or last; #RETRY
				}
				open SAVE, ">save/save$num.sav" or print "$c{e}Could not write to save/save$num.sav\n" and last; #RETRY
				my $info;
				for my $hash (@hash) {
					$info .= "$hash";
					for my $key (keys %{$hash}) {
						for(keys %{"lock_$hash"}) {
							if(!index $_, $key and ${$hash}{$key} eq ${"lock_$hash"}{$_}) {
							$info .= "\t$_";
							}
						}
					}
					for(keys %{"start_$hash"}) {
						if(!${$hash}{$_}) {
							$info .= "\tno_$_";
						}
					}
					$info .= "\n";
				}
				$info .= "msgnum";
				for(keys %msgnum) {
					$info  .= "\t$_\t${'msgnum'}{$_}";
				}
				$info .= "\nstate";
				for(keys %state) {
					$info  .= "\t$_\t${'state'}{$_}";
				}
				print SAVE $info;
				close SAVE;
				print "$c{s}Saved in slot $num successfully!\n";
				return;
			}
			else { print "$c{e}That is not a slot number from 1 to 9\n"; }
		}
		else {
			if(&saved_games()) {
				print "$c{t}Your Saved Games\n$c{sav}", &saved_games();
			}
			print " $c{ooc}Q: Save in which slot?\n A: ";
			my @args = split ",", &bite(scalar <STDIN>);
			if(defined $args[0]) {
				&save(@args);
			}
			else {
				&save("");
			}
			return;
		}
	}
	print " $c{ooc}Q: Try saving again?\n";
	if(&yes()) {
		&save();
	}
}

1;