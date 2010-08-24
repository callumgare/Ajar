#!/usr/bin/perl
use warnings;

### USE_IFTREE ###

sub use_iftree {
	my ($item, $key) = @_;
	if($item eq "mobile phone" or $item eq "paperclip") {
		&to_look("left pocket");
		&to_look("right pocket");
	}
}

sub do_use {
	my ($item, $key) = @_;
	$key eq "mobile phone2" or $key eq "mobile phone3"
	or $key eq "paperclip" and &hasheq("lock look_1 paper3")
	
	or $item eq "key"
	;
}

sub dont_use {
	my ($item, $key) = @_;
	$key eq "mobile phone"
	
	
	;
}

1;