#!/usr/bin/perl
use warnings;

### REACH ###

@help = ( #items that do provide reaching help

);

# Template: #
# ${"reach". %state{player}}{$msgnum . $key (. "-" . $help)} = $success . "$message"; #

%reach0 = (
"0right pocket" => "You shrug your right shoulder as high as it can go, the only movement the ropes will allow. You angle your wrist sharply and manage to get your 4th and 5th fingers half-way into the pocket. Your fingers straight away come into contact with paper.-10",
"-1right pocket" => "You do the same with your right hand but this time, your fingers catch on something paper.-10",

"-10right pocket" => "There is a piece of paper in your right hand.",
"-9right pocket" => "You are holding a piece of paper.-10",

"-20right pocket" => "You get your last two fingers into the pocket the same way. You strain your wrist to push them in as far as you can when they finally touch something else. You eventually slide it up enough to be able to pull it out. It's your mobile phone.",
"-19right pocket" => "Your mobile phone is in your right hand.",
"-18right pocket" => "You are holding your mobile phone.-19",

"1right pocket" => "1You reach into your right pocket making sure you don't drop the battery.",
"2right pocket" => "1Yep you reach in, keeping hold of the battery.",
"3right pocket" => "1Reaching into right pocket is fun while holding a battery.",

"0left pocket" => "1You shrug your left shoulder as high as it can go, the only movement the ropes will allow. You angle your wrist sharply and manage to get your 4th and 5th fingers half-way into the pocket. You move the fingers around but you can't seem to find anything.",
"-1left pocket" => "1You do the same with your left hand but this time you find nothing.1",
"1left pocket" => "1You reach into your left pocket.",
"2left pocket" => "1Yep you reach in.",
"3left pocket" => "1Reaching into left pocket is fun.",

"1no" => "There is no way you can reach it, your hands are tied up. You can barely even reach your own pockets.",
"2no" => "You can't reach that.",
"3no" => "The ropes don't budge, you're not going to be reaching that.",
"4no" => "You momentarily think you can reach it, but then you realise there's no way you can.",
"5no" => "It's not right next to your hands, so you can't reach it",
"6no" => "You sigh deeply, you're not going to reach that.",
);

%reach1 = (
"0right pocket" => "You test your right hand, twisting it back and fourth in agony. The ropes around it soon fall away. With your arm now only tied at the elbow, you bring your hand up near your chest. It's covered in burnt skin, ranging from bright red to black. You soon reach back into the right pocket. It's not much easier at all and can't find anything else in there.1",
"-1right pocket" => "With only your wrist free, you can't reach into the pocket much easier at all. You still can't find anything else in there.",
"1right pocket" => "You reach into your right pocket finding nothing else.",
"2right pocket" => "You reach in but find nothing.",
"3right pocket" => "Reaching into left pocket is fun.",

"0left pocket" => "You test your right hand, twisting it back and fourth in agony. The ropes around it soon fall away. With your arm now only tied at the elbow, you bring your hand up near your chest. It's covered in burnt skin, ranging from bright red to black. You soon reach back over into the left pocket. You get your thumb all the way down with a bit of effort. It touches something metal. You ease it out of the pocket, scratching yourself as you do so. When it's out, you can see that it is a metal key.",
"-1left pocket" => "With your right hand free at the wrist you are able to reach over to your left pocket with it. You get your thumb all the way down with a bit of effort. It touches something metal. You ease it out of the pocket, scratching yourself as you do so. When it's out, you can see that it is a metal key.1",
"1left pocket" => "You reach in again but there seems to be nothing else in there.",
"2left pocket" => "You reach in but you can't find anything else.",
"3left pocket" => "Nothing else is found when you reach in again.",

"1no", "You still can't reach that. Only your right wrist is free from the ropes.",
"2no", "You can't reach that with only your right wrist free.",
"3no", "Only your right wrist is free so you can't reach it.",
);

1;