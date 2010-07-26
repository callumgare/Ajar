#!/usr/bin/perl
use warnings;

### ACTIONS ###

sub look {
	my ($item, @others) = @_;
	if(@others) {
		print "$c{e}Looking at first value only\n";
	}
	if(!@_) {
		&print_list("look");
	}
	elsif(($look{$item} or $inventory{$item}) and $look_1{$item}) {
		$_ = $look_1{$item};
		if(s/^(\d+)//) { #remove and store leading digits
			&unlock("look_1 $item$1"); #digit tells us which look_1 to unlock
		}
		print "$c{n}$_\n";
		&look_iftree($item);
	}
	elsif($item eq "inventory") {
		&print_list("inventory");
	}
	else {
		print "$c{e}You can't see \"$item\"\n";
	}
}

sub combine {
	my @item = @_;
	&delete_repeats(\@item);
	if(!@item) {
		&redo("combine", 1);
	}
	else {
		my ($fail, @itemkey);
		for(@item) {
			if(!$inventory{$_}) {
				if($look{$_}) {
					print "$c{e}You can't reach \"$_\"\n";
				}
				else {
					print "$c{e}You can't see \"$_\"\n";
				}
				$fail = 1;
			}
			elsif(!$fail) {
				push @itemkey, &keyify($_);
			}
		}
		if(!$fail) {
			if(@item == 1) {
				&redo("combine", 0, $item[0]);
			}
			else {
				my $key = join "-", sort @itemkey; #sorted items separated by -
				if(exists ${"combine$state{player}"}{"0$key"} or exists ${"combine$state{player}"}{"1$key"}) {
					my ($msg, $num) = &hash_message("combine$state{player}", $key);
					(my $item, $msg) = split "\t", $msg;
					if(!$msg) {
						$msg = $item;
					}
					else {
						for(@item) {
							delete $inventory{$_}; #delete every item we combine
						}
						&unlock("inventory $item"); #unlock the created item
					}
					&msgnum_change("combine$state{player} $key", \$msg);
					print $c{n}.$msg;
					
					&combine_iftree($key, $num);
					
					&empty_inventory();
				}
				else {
					print "$c{e}You can't think of a way to combine " . &make_list(@item) . "\n";
				}
			}
		}
	}
}

sub reach {
	my ($item, $help, @others) = @_;
	if(@others) {
		print "$c{e}Reaching for first value with second value only.\n";
	}
	if(!@_) {
		&print_list("inventory");
	}
	elsif($inventory{$item}) {
		print "$c{e}You can already reach \"$item\"\n";
	}
	elsif(!$look{$item}) {
		print "$c{e}You can't see \"$item\"\n";
	}
	else {
		my $key = &keyify($item, 1);
		my ($msg, $num);
		if($help) {
			if($inventory{$help}) {
				if(!grep $help eq $_, @help) {
					print "$c{e}You can't use \"$help\" for reaching.\n";
					undef $help;
				}
				elsif(exists ${"reach$state{player}"}{"0$key-$help"} or exists ${"reach$state{player}"}{"1$key-$help"}) {
					($msg, $num) = &hash_message("reach$state{player}", "$key-$help");
				}
				else {
					$help = 0;
				}
			}
			else {
				if($look{$help}) {
					print "$c{e}You can't reach helping item: \"$help\"\n";
				}
				else {
					print "$c{e}You can't see helping item: \"$help\"\n";
				}
				undef $help;
			}
		}
		if(!$help) {
			if(exists ${"reach$state{player}"}{"1$key"} or exists ${"reach$state{player}"}{"1$key"}) {
				if(defined $help) {
					print "$c{e}You can reach \"$item\" without a helping item";
				}
				($msg, $num) = &hash_message("reach$state{player}", "$key");
			}
			else {
				($msg, $num) = &hash_message("reach$state{player}", "no");
			}
		}
		&msgnum_change("reach$state{player} $key", \$msg);
		$msg =~ s/^(\d)//; #take off the success number and store it in $1
		print $c{n}.$msg;
		if($1) {
			&to_inventory($item);
		}
		if(&hasheq("start inventory title!")) {
			&unlock("inventory title!");
		}
		
		&reach_iftree($item, $num);
		
		&empty_inventory();
	}
}

sub separate {
	my ($item, @others) = @_;
	if(@others) {
		print "$c{e}Separating the first value only.\n";
	}
	if(!@_) {
		&redo("separate");
	}
	elsif(!$inventory{$item}) {
		if($look{$item}) {
			print "$c{e}\u$item is not in your inventory\n";
		}
		else {
			print "$c{e}\uYou can't see \"$item\"\n";
		}
	}
	else {
		my $key = &keyify($item);
		my ($msg, $num, @item);
		if(exists ${"separate$state{player}"}{"0$key"} or exists ${"separate$state{player}"}{"1$key"}) {
			($msg, $num) = &hash_message("separate$state{player}", $key);
			(my $items, $msg) = split "\t", $msg;
			if(!$msg) {
				$msg = $items;
			}
			else {
				delete $inventory{$item}; #delete the item we separate
				@item = split "-", $items;
				for(@item) {
					&unlock("inventory $_"); #unlock all the created items
				}
			}
			&msgnum_change("separate$state{player} $key", \$msg);
			print $c{n}.$msg;
			
			&separate_iftree($item, $key, $num);
			
			&empty_inventory();
		}
		else {
			print "$c{e}You can't think of a way to separate \"$item\"\n";
		}
	}
}

sub use {
	my ($item, @others) = @_;
	if(@others) {
		print "$c{e}Using the first value only.\n";
	}
	if(!@_) {
		&redo("use");
	}
	elsif(!$inventory{$item}) {
		if($look{$item}) {
			print "$c{e}You can't reach \"$item\"\n";
		}
		else {
			print "$c{e}You can't see \"$item\"\n";
		}
	}
	else {
		my $key = &keyify($item);
		if(&do_use($item, $key)) {
			&use_loop($item, $key, "");
		}
		elsif(&dont_use($item, $key)) {
			&print_hash("use0", $key);
		}
		else {
			print "$c{e}You can't think of a way to use \"$item\"\n";
		}
	}
}

sub use_loop {
	my ($item, $key, $mod) = @_;
	my ($func);
	my ($name, $act, $verb) = ("", "", "");
	if($mod) {
		($name, $act, $verb) = split "\t", $mod;
		$func = "use__".$name."_".$act."_";
	}
	else {
		$func = "use_".$item."_";
		$func =~ s/ /_/g;
	}
	if(!defined ${$func."actions"}) {
		my $litem = ($mod ? "$name $verb" : $item);
		${$func."actions_0"}{actions} = "$c{ooc}View the actions for the $litem";
		${$func."actions_0"}{stop} = "Stop ". ($mod ? "$verb with the $name" : "using the $item");
		%{$func."actions"} = (
			"title!" => "\u$litem actions",
			%{$func."actions_1"},
			%{$func."actions_0"},
		);
	}

	&print_list($func."actions", $mod); #give them the actions list straight away
	&use_iftree($item, $key, $mod); #do anything related to starting using an item
	while(1) {
		if($mod) {
			print "\n$c{l}use>$c{i}$name>$c{a}$act $item>$c{avuu}";
		}
		else {
			print "\n$c{l}use>$c{i}$item>$c{avu}";
		}
		my ($action, @args) = &break_input($mod);
		if(${$func."actions"}{$action}) {
			$state{actioncount}++;
		}
		if(@args) {
			if(${$func."actions_1"}{$action}){
				exists &{$func.$action."_1"} ? &{$func.$action."_1"}(@args)
				: exists &{$func.$action} ? &{$func.$action}(@args)
				: exists &{"use_".$action} ? &{"use_".$action}($item, $key, @args) : 0;
			}
			elsif(${$func."actions_0"}{$action} or $action eq "clear" or $action eq "exit") {
				print "$c{e}Ignoring unnecessary values for $action.\n";
				undef @args;
			}
			else { undef @args; }
		}
		if(!@args) {
			if($action eq "stop") {
				print "$c{n}You stop ". ($verb ? $verb : "using") ." the $item\n";
				last;
			}
			elsif(${$func."actions_0"}{$action}) {
				exists &{$func.$action."_0"} ? &{$func.$action."_0"}()
					: exists &{$func.$action} ? &{$func.$action}()
					: exists &{"use_".$action} ? &{"use_".$action}($item, $key)
					: &print_list($func.$action);
			}
			elsif(${$func."actions_1"}{$action}) {
				exists &{$func.$action."_1"} ? &{$func.$action."_1"}()
				: exists &{$func.$action} ? &{$func.$action}()
				: exists &{"use_".$action} ? &{"use_".$action}($item, $key) : 0;
			}
			elsif($action eq "clear") {
				&clear_0();
			}
			elsif($action eq "exit") {
				&exit_0();
			}
			elsif($mod eq "key	cut	cutting" and $action =~ /^[-\\|\/]$/) {
				&use__key_cut_s($action);
			}
			else {
				print "$c{e}Unknown Action or Command: \"$action\"";
			}
		}
	}
}

sub look_0 {
	if(&print_message("look") == 1) {
	&unlock_action(1, "look");
	&unlock("actionhelp look");
	delete $actions_0{look};
	delete $msgnum{look}; #cleanup

	&unlock_action(1, "combine");
	&unlock_action(1, "reach");
	&unlock_action(1, "separate");
	&unlock_action(1, "use");
	}
}

1;