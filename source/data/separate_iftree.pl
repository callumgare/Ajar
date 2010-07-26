#!/usr/bin/perl
use warnings;

### SEPARATE_IFTREE ###

sub separate_iftree {
	my ($item, $key, $num) = @_;
	if($state{player} == 0) {
		if($key eq "mobile phone4") {
			&to_look("mobile phone");
			&unlock("look_1 mobile phone4");
			$msgnum{"separate0 paper2"} = -30;
			$msgnum{"reach0 right pocket"} = 1;
			&to_look("left pocket");
		}
		elsif($item eq "paper") {
			if($num == -30) {
				&to_look("paper");
				&unlock("look_1 paper2");
				&to_look("left pocket");
				&to_look("right pocket");
			}
		}
	}
}

1;