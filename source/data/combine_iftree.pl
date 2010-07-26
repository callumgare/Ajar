#!/usr/bin/perl
use warnings;

### COMBINE_IFTREE ###

sub combine_iftree {
	my ($key, $num) = @_;
	if($state{player} == 0) {
		if($key eq "battery-paperclip2") {
			$state{player} = 1; #congratz
			undef %msgnum; #cleanup player-state 0
			&to_look("left pocket");
			&to_look("right pocket");
			&unlock("look metal shards");
			&to_inventory("chair");
			&unlock("look_1 chair");
			&to_inventory("ropes");
			&to_inventory("head");
			&unlock("look_1 ropes");
		}
	}
}

1;