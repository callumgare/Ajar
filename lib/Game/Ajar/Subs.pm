#!/usr/bin/perl
use warnings;

sub bite {
	($_, my $x) = @_;
	if(!defined) { #must be an interrupt signal...
		$_ = "\n";
		print; #it's just like we did return the line
	}

	if(!-d "save") {
		mkdir "save", 0755 or print "$c{e}Could not create save directory for log\n" and return;
	}
	open LOG, ">>save/log.txt" or print "$c{e}Could not write to log file\n" and return;
	print LOG $_;
	close LOG;

	chomp; #remove the newline before we count the chars
	$state{lettercount} += length;

	$_ = lc;
	if($x) {
		$x eq "key	cut	cutting" and $x = '-\\\\|/';
	}
	$x .= "a-z1-9";
	s/^[^$x]+|[^$x]+$//g; #trim leading and trailing non-$x
	s/[^$x,]+/ /g; #replace all other non-$x/non-comma with a space
	s/ ?,+ ?/,/g; #trim space before and after commas. One comma at a time
	$_;
}

sub saved_games {
	my $games;
	while(<save/save*.sav>) {
		if(-s and s/^save\/save([1-9]).sav$/Save $1/) {
			my ($sec, $min, $hr, $day, $mon, $yr) = localtime((stat _)[9]); #(stat _)[9] is mtime
			$games .= sprintf "%s - %02d/%02d/%4d %2d:%02d:%02d\n", $_, $day, $mon+1, $yr+1900, $hr, $min, $sec;
		}
	}
	$games;
}

sub print_list {
	my ($action) = @_;
	print "$c{t}${$action}{'title!'}\n";

	my $av =
	  !index($action, "use__") ? "avuu"
	: !index($action, "use_") ? "avu"
	: "av";
	my ($c, $d) = ("n", "n");
	if($action eq "commands" or $action eq "alias") {
		$c = "av";
		$d = "ooc";
	}
	elsif($action eq "help" or $action eq "keys") {
		$c = "ooc";
		$d = "ooc";
	}
	elsif($action eq "look" or $action eq "inventory") {
		$c = "av";
	}
	if($action =~ /actions$/) {
		$c = $av;
	}
	for(sort {
		if($a =~ /^(\d+)/) {
			my $_1 = $1;
			if($b =~ /^(\d+)/) {
				return $_1 <=> $1;
			}
			else {
				return -1;
			}
		}
		elsif($b =~ /^(\d+)/) {
			return 1;
		}
		"\L$a" cmp "\L$b";
	} grep { $_ ne "title!" and ${$action}{$_} ne "!" } keys %{$action}) {
		my $key = $_;
		my $range = chr(ord("z") + 1) ."-". chr(0xFF);
		s/^\d+|^[$range]//;
		printf "%s%-15s %s%s\n", $c{$c}, $_, $c{$d}, ${$action}{$key};
	}
}

sub yes {
	my ($no) = @_;
	my $input;
	while(1) {
		print " A: ";
		$input = &bite(scalar <STDIN>);
		if($input =~ /^(y+((e+a*(h*|p*|r*)(s*|z*)|a+(e*|r*|wai)h*(s*|z*))?(a+r+)?)*|inde+d|aye( aye)?|affirmative)$/) {
			return 1;
		}
		elsif($input =~ /^(n+(((a+|e+)(r+p+|r*h+|h+r+)|o+(h*|p+e*|(n+o+)+|wai)?|y*u+p+)(s*|z*))?|nev(a+|e+)r+|negative)$/) {
			return 0;
		}
		else {
			my $msg = "That is not a valid yes or no answer\n";
			if(!$no) {
				$msg = $c{e}.$msg.$c{ooc};
			}
			print $msg;
		}
	}
#y ye yes yea, yeh yehs yeah yeahs, yep yeps yeap yeaps, yer yers year years, ya yah yahs, yae yaeh yaehs, yar yarh yarhs, indeed, aye aye, affirmative, yawai yawais yawaih yawaihs
#n na nars narh nahrs narp narps, nahr nahrs, ne ners nerh nehrs nerp nerps, nehr nehrs, no noh nohs nos, nop nope nopes nops, nono, nup nyup nups nyups, nevar never, negative, nowai noawais
}

sub break_input {
	my ($mod) = @_;
	my $input = &bite(scalar <STDIN>, $mod);
	$input =~ s/^([^ ,]*)[ ,]?//; #remove action and store it in $1
	my @items = ($1, split ",", $input);
	@items;
}

sub print_message {
	my ($msg) = @_;
	if(!$msgnum{$msg}) {
		$msgnum{$msg} = 0;
	}
	print "$c{n}";
	if(${$msg}[$msgnum{$msg}]) {
		print "${$msg}[$msgnum{$msg}]\n";
	}
	else {
		$msgnum{$msg} = 1; #nothing at the old msgnum value so were starting back at 1
		print "${$msg}[1]\n";
	}
	$msgnum{$msg}++;
}

sub hash_message {
	my ($hash, $msg) = @_;
	if(!$msgnum{"$hash $msg"}) {
		$msgnum{"$hash $msg"} = 0;
	}
	if(${$hash}{$msgnum{"$hash $msg"}.$msg}) {
		return ("${$hash}{$msgnum{$hash.' '.$msg}.$msg}\n", $msgnum{"$hash $msg"}++);
	}
	else {
		$msgnum{"$hash $msg"} = 2; #nothing at the old msgnum value so were starting back at 1 (next is 2)
		return ("${$hash}{'1'.$msg}\n", 1);
	}
}

sub print_hash {
	my ($hash, $msg) = @_;
	($msg) = &hash_message($hash, $msg);
	print $c{n}.$msg;
}

sub unlock_action {
	my ($num, $action) = @_;
	${"actions_$num"}{$action} = ${"lock_actions_$num"}{$action};
	$actions{$action} = ${"lock_actions_$num"}{$action};
	&alias($action, "!"); #make sure to get rid of aliases in the name of the actual action
}

sub unlock {
	my ($str) = @_;
	my ($hash, $item, $num) = split " ", $str, 2;
	if($item =~ s/(\d+)$//) {
		$num = $1 > 1 ? $1 : "";
	}
	else {
		$num = "";
	}
	${$hash}{$item} = ${"lock_$hash"}{$item.$num};
}

sub redo {
	my ($action, $plural, $arg, $level) = @_;
	$level or $level = 0;
	my @args;
	if($arg) {
		print "$c{e}Combine \"$arg\" with what?\n$c{l} >$c{av}$action $arg, ";
		@args = ($arg);
	}
	else {
		if($plural) { print"$c{e}Values"; }
		else { print "$c{e}Value"; }
		my $dispa = $action;
		$dispa =~ s/_/ /g;
		my @words = split " ", $dispa;
		my ($str, $actn);
		if($level == 2) {
			shift @words;
			$actn = pop @words;
			my $act = pop @words;
			my $item = join " ", @words;
			$str = "$c{i}$item $c{a}$act$c{luu}>$c{avuu}";
		}
		elsif($level) {
			shift @words;
			$actn = pop @words;
			my $item = join " ", @words;
			$str = "$c{i}$item$c{lu}>$c{avu}";
		}
		else {
			$str = "$c{l}> $c{av}";
			$actn = $action;
		}
		print " required for $dispa, try again.\n $str$actn ";
	}
	push @args, split ",", &bite(scalar <STDIN>);
	&{$action}(@args);
}

sub to_inventory {
	my ($item) = @_;
	&unlock("inventory $item");
	delete $look{$item};
}

sub to_look {
	my ($item) = @_;
	&unlock("look $item");
	delete $inventory{$item};
}

sub hasheq {
	# "lock|start $hash $item$num" #
	my ($str) = @_;
	my ($type, $hash, $item, $num) = split " ", $str, 3;
	if($item =~ s/(\d+)$//) {
		$num = $1;
	}
	else {
		$num = "";
	}
	if(${$hash}{$item}) {
		if(!${$type."_$hash"}{$item.$num}) {
			print "\${$hash}{$item} eq \${$type.'_$hash'}{$item.$num}"; #debugging purposes only
		}
		else {
			${$hash}{$item} eq ${$type."_$hash"}{$item.$num};
		}
	}
}

sub make_list {
	my @list = @_;
	my $list;
	while(@list) {
		$_ = shift @list;
		if(!@list) {
			$list .= $_;
		}
		elsif(@list == 1) {
			$list .= "$_ and ";
		}
		else {
			$list = "$_, ";
		}
	}
	$list;
}

sub msgnum_change {
	my ($key, $msg) = @_;
	if($$msg =~ s/(-?\d+)$//) {
		$msgnum{$key} = $1;
	}
}

sub play {
	my ($name, $sync) = @_;
	if($sync) { $sync = "" }
	else { $sync = SND_ASYNC; }
	Win32::Sound::Play("sound/$name.wav", $sync);
}

sub delete_repeats {
	my @item = @{$_[0]};
	my ($repeat, @new);
	for my $key (@item) {
		my $num = push @new, $key; #store the new number of items in the array
		if($num > 1) {
			for(0..$num - 2) {
				if($new[$_] eq $key) {
					pop @new; #it's already on so take it off
					$repeat = 1;
					last;
				}
			}
		}
	}
	if($repeat) {
		print "$c{e}Repeated values deleted\n";
	}
	@{$_[0]} = @new;
}

sub empty_inventory {
	$_ = scalar keys %inventory;
	if($_ < 2) { #if there's only one thing in the hash, it's title! so the inventory is empty
		&unlock("inventory title!2");
	}
}

sub keyify {
	my ($item, $look) = @_;
	$hash = $look ? "look" : "inventory";
	for(keys %{"lock_$hash"}) {
		if(${$hash}{$item} eq ${"lock_$hash"}{$_}) {
			$item = $_;
			last;
		}
	}
	$item;
}

sub add_ing {
	($_) = @_;
	my %exception = (
		
	);
	my $v = "aeiou";
	if($exception{$_}) {
		$_ = $exception{$_};
	}
	elsif(/[y$v][^$v]e$/) {
		chop;
	}
	elsif(!(/[^bdgmnprt]$/ or /[^$v].$/ or /[$v]{2}.$/ or /[$v]+[^$v]+[$v]+[nm]$/)) {
		#has to end in [bdgmnprt] to double
		#can't double if there's a consonant before that letter
		#can't double if there's 2 vowels before that letter
		#can't double if it's a multiple syllable word ending in [nm], such as listening
		$_ .= chop() x 2;
	}
	$_ . "ing";
}

1;