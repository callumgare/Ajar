#!/usr/bin/perl
use warnings;

sub use_mobile_phone_power {
	if(!$msgnum{mobile_phone_silent}) {
		if(!$msgnum{mobile_phone_power}) {
			$msgnum{mobile_phone_power} = 1;
			if(&hasheq("lock inventory mobile phone2")) {
				&unlock("inventory mobile phone3");
				&unlock("look_1 mobile phone2");
			}
			&print_hash("use0", "power on");
		}
		else {
			$msgnum{mobile_phone_power} = 0;
			&print_hash("use0", "power off");
		}
	}
	else {
		if($msgnum{mobile_phone_call}) {
			if(!$msgnum{mobile_phone_power}) {
				&print_hash("use0", "no");
			}
			else {
				$msgnum{mobile_phone_power} = 0;
				&print_hash("use0", "power off");
			}
		}
		else {
			if(!$msgnum{mobile_phone_power}) {
				$msgnum{mobile_phone_power} = 1;
				&print_hash("use0", "power on-silent");
			}
			else {
				$msgnum{mobile_phone_power} = 0;
				&print_hash("use0", "power off");
			}
		}
	}
}

sub use_mobile_phone_silent {
	if($msgnum{mobile_phone_power}) {
		if($msgnum{mobile_phone_call}) {
			&print_hash("use0", "no");
		}
		elsif(!$msgnum{mobile_phone_silent}) {
			$msgnum{mobile_phone_silent} = 1;
			&print_hash("use0", "silent off");
		}
		else {
			$msgnum{mobile_phone_silent} = 0;
			&print_hash("use0", "silent on");
		}
	}
	else {
		&print_hash("use0", "off");
	}
}

sub use_mobile_phone_call {
	if($msgnum{mobile_phone_power}) {
		if($msgnum{mobile_phone_call}) {
			&print_hash("use0", "no");
		}
		elsif(!$msgnum{mobile_phone_silent}) {
			$msgnum{"use0 call-silent"} = -1;
			&print_hash("use0", "call");
		}
		else {
			$msgnum{mobile_phone_call} = 1;
			$msgnum{"use0 power off"} = -1;
			&unlock("inventory mobile phone4");
			&unlock("look_1 mobile phone3");
			$msgnum{"separate0 paper2"} = -20;
			&print_hash("use0", "call-silent");
		}
	}
	else {
		&print_hash("use0", "off");
	}
}

sub use_paperclip_bend {
	&print_hash("use0", "bend");
	if(&hasheq("lock inventory paperclip")) {
		&unlock("inventory paperclip2");
		&unlock("look_1 paperclip");
	}
}

sub use_key_cut {
	my ($item) = @_;
	if($item) {
		if($inventory{$item}) {
			if($item eq "chair") {
				my $key = &keyify($item);
				if($key eq "chair") {
					&print_hash("use1", "cut_chair");
					&unlock("inventory chair2");
					&unlock("look_1 chair2");
				}
				if($key ne "chair3") {
					&use_loop($item, $key, "key	cut	cutting");
				}
				else {
					&print_hash("use1", "cut_chair");
				}
			}
			elsif($item eq "head" or $item eq "ropes") {
				&print_hash("use_1", "cut_$item");
				if($item eq "head" and &hasheq("lock inventory head")) {
					&unlock("inventory hair");
				}
			}
			else {
				print "$c{e}You cannot think of any useful way to cut \"$item\"";
			}
		}
		elsif($look{$item}) {
			print "$c{e}You can't reach \"$item\"";
		}
		else {
			print "$c{e}You can't see \"$item\"";
		}
	}
	else {
		&redo("use_key_cut", 0, 0, 1);
	}
}

sub use__key_cut_s {
	my ($char) = @_;
	my ($cols, $rows) = (4,6);
	if(!$msgnum{ccurrent}) {
		$msgnum{ccurrent} = "0,0"; #start top left
		$msgnum{cdir} = "0,1"; #start moving down with no xdir
	}
	my ($x, $y) = split ",", $msgnum{ccurrent};
	my ($xd, $yd)= split ",", $msgnum{cdir};
	my $yes = 0;
	
	if($char eq "-") {
		if(($x == 0 or $x == $cols) and ($y == 0 or $y == $rows) and $xd and $yd) { #corner and diagonal
			if($x) {
				$xd = -1;
			}
			else {
				$xd = 1;
			}
			$yd = 0;
			$yes = 1;
		}
		elsif($xd) {
			if($x + $xd >= 0 and $x + $xd <= $cols) {
				$yd = 0;
				$yes = 1;
			}
		}
		elsif($yd > 0 and $y == $rows or $yd < 0 and $y == 0) {
			if($x > int($cols / 2)) {
				$xd = -1;
			}
			else {
				$xd = 1;
			}
			$yd = 0;
			$yes = 1;
		}
	}
	elsif($char eq "\\") {
		if($yd) {
			if($x + $yd >= 0 and $x + $yd <= $cols and $y + $yd >=0 and $y + $yd <= $rows) {
				$xd = $yd;
				$yes = 1;
			}
		}
		elsif($x + $xd >= 0 and $x + $xd <= $cols and $y + $xd >= 0 and $y + $xd <= $rows) {
			$yd = $xd;
			$yes = 1;
		}
	}
	elsif($char eq "|") {
		if(($x == 0 or $x == $cols) and ($y == 0 or $y == $rows) and $xd and $yd) { #corner and diagonal
			if($y) {
				$yd = -1;
			}
			else {
				$yd = 1;
			}
			$xd = 0;
			$yes = 1;
		}
		elsif($yd) {
			if($y + $yd >= 0 and $y + $yd <= $rows) {
				$xd = 0;
				$yes = 1;
			}
		}
		elsif($xd > 0 and $x == $cols or $xd < 0 and $x == 0) {
			if($y > int($rows / 2)) {
				$yd = -1;
			}
			else {
				$yd = 1;
			}
			$xd = 0;
			$yes = 1;
		}
	}
	elsif($char eq "/") {
		if($yd) {
			if($x - $yd >= 0 and $x - $yd <= $cols and $y + $yd >=0 and $y + $yd <= $rows) {
				$xd = -$yd;
				$yes = 1;
			}
		}
		elsif($x + $xd >= 0 and $x + $xd <= $cols and $y - $xd >= 0 and $y - $xd <= $rows) {
			$yd = -$xd;
			$yes = 1;
		}
	}
	if($yes) {
		$msgnum{"cc$x,$y"} = $char;
		$x += $xd;
		$y += $yd;
		$msgnum{ccurrent} = "$x,$y";
		$msgnum{cdir} = "$xd,$yd";
		$state{cminutes}++;
	}
	else {
		print "$c{e}Cannot cut in that direction\n";
	}
	my $total = ($cols+1) * ($rows+1);
	my $remain = $total;
	for my $row (0..$rows) {
		for(0..$cols) {
			if("$_,$row" eq "$x,$y") {
				print $c{sel};
			}
			elsif($row % 2 and $_ % 2 or !($row % 2) and !($_ % 2)) { #checker pattern
				print $c{lgt};
			}
			else {
				print $c{drk};
			}
			if($msgnum{"cc$_,$row"}) {
				print $msgnum{"cc$_,$row"};
				$remain--;
			}
			else {
				print " ";
			}
		}
		print "$c{bg}\n";
	}
	if($remain) {
		print "Remaining: $remain";
	}
	else {
		print $c{n};
		if($state{cminutes} == $total) {
			print "You cut the chair with amazing efficiency and after $state{cminutes} minutes, you are able to get";
		}
		else {
			print "After $state{cminutes} minutes of cutting the chair, you are finally able to get";
		}
		print " some of the foam filling out. It comes out in clumps, the largest of which you keep in your hand, the rest you let fall to the ground beneath you. You also salvage some of the fabric cover of the chair which is in the form of short strips.";
		&unlock("inventory chair3");
		&unlock("look_1 chair3");
		&unlock("inventory foam");
		&unlock("inventory fabric");
	}
}

# sub x {
	# &print_hash("use1", "");
	# print "A booming voice says, \"Congratulations, you finished the tutorial in $state{actioncount} actions and a total of $state{lettercount} characters.\"
# This is the end of the game for now. More to come soon.
# ";
	# scalar <STDIN>;
	# exit;
# }

1;