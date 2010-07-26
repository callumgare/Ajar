#!/usr/bin/perl
use warnings;

### LOOK_IFTREE ###

sub look_iftree {
	my ($item) = @_;
	if($state{player} == 0) {
		if($item eq "paper" and &hasheq("lock inventory paper")) {
			&unlock("inventory paper2");
			$msgnum{"reach0 right pocket"} = -20;
			&unlock("look up");
			&to_look("left pocket");
		}
		elsif($item eq "mobile phone" and &hasheq("lock inventory mobile phone")) {
			&unlock("inventory mobile phone2");
		}
	}
}

1;