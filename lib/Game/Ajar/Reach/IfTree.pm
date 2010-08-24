#!/usr/bin/perl
use warnings;

### REACH_IFTREE ###

sub reach_iftree {
	my ($item, $num) = @_;
	if($state{player} == 0) {
		if($item eq "right pocket") {
			if($num == 0) {
				$msgnum{"reach0 left pocket"} = -1;
			}
			else {
				if($num == -20) {
					&unlock("inventory mobile phone");
					$msgnum{"separate0 paper2"} = -10;
				}
				elsif($num < -1) {
					return;
				}
				&to_look("left pocket");
			}
			if($num == 0 or $num == -1) {
				&unlock("inventory paper");
			}
		}
		elsif($item eq "left pocket") {
			if($num == 0) {
				$msgnum{"reach0 right pocket"} = -1;
			}
			else {
				&to_look("right pocket");
			}
		}
	}
	elsif($state{player} == 1) {
		if($item eq "left pocket") {
			if($num == 0 or $num == -1) {
				&unlock("inventory key");
				if($num == 0) {
					$msgnum{"reach1 right pocket"} = -1;
				}
			}
		}
		elsif($item eq "right pocket" and $num == 0) {
			$msgnum{"reach1 left pocket"} = -1;
		}
	}
}

1;