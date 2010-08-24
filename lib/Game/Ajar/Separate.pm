#!/usr/bin/perl
use warnings;

### SEPARATE ###

# Template: #
# ${"separate". %state{player}}{$msgnum . $key} =  join "\t", @itemsgenerated . "\t" . "$message"; #

%separate0 = (
"0mobile phone" => "You should check to see if it's working before pulling it apart.",
"1mobile phone" => "You need to know if it works before pulling it apart.",
"2mobile phone" => "Before pulling it apart, you need to know if it works or not.",

"0mobile phone2" => "This could be your way out, you can't pull it apart.",
"1mobile phone2" => "You don't want to pull it apart.",
"2mobile phone2" => "The phone could get you out of this, you don't pull it apart.",

"0mobile phone3" => "The phone could get you out of this, you don't pull it apart.",
"1mobile phone3" => "You don't want to pull it apart.",
"2mobile phone3" => "This could be your way out, you can't pull it apart.",

"0mobile phone4" => "battery	You turn the phone over in your hand and push firmly on the back of the phone. With some difficulty, the back cover slides off. You let it fall to the ground. You then dislodge the battery, making sure that you are holding it securely between your thumb and index finger before letting go of the phone. The phone bounces on the concrete, then lands face-down.",

"1paper" => "You need to get it into a better position to look at.",
"0paper2" => "You feel there is something else rather heavy in your right pocket.",
"1paper2" => "You stop when you feel that your right pocket something else in it.",
"2paper2" => "You feel there is something else in your right pocket.",

"-10paper2" => "You have a mobile phone in your right hand. You can't risk dropping it.",
"-9paper2" => "There is a mobile phone in your hand.",
"-8paper2" => "You have a mobile phone in your right hand.-9",

"-20paper2" => "You have a mobile phone in your right hand.",
"-19paper2" => "There is a mobile phone in your hand.",
"-18paper2" => "You have a mobile phone in your right hand.-19",

"-30paper2" => "paperclip	You take the paperclip off the corner of the paper, battery in hand. The paper falls to the ground, it floats and spins around and lands its other side.",
);

1;