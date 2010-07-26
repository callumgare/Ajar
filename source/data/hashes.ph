#!/usr/bin/perl
use warnings;

%start_look = (
"title!" => "You See:",
"{inventory" => "All other items that are in arm's-reach",
"inventory" => "!",
"right pocket" => "Your right pocket",
"left pocket" => "Your left pocket",
"vomit" => "Vomit on the ground beside you",
"chair" => "The chair you are sitting on",
"head" => "Your head. It hurts",
"ropes" => "The ropes that tie you down to the chair",

);

%lock_look = (
"right pocket" => $start_look{"right pocket"},
"left pocket" => $start_look{"left pocket"},
"up" => "Above you",
"paper" => "Paper on the ground near you",
"mobile phone" => "Phone on the ground missing a battery",
"metal shards" => "Several metal shards of varying size on the ground near you",
);

%start_inventory = ("title!" => "There is nothing in arm's-reach.");
%lock_inventory = (
"title!" => "Things in arm's-reach:",
"title!2" => $start_inventory{"title!"},
"right pocket" => $start_look{"right pocket"},
"left pocket" => $start_look{"left pocket"},
"paper" => "A piece of paper in your right hand",
"paper2" => "A note laying wrong-way-up on you lap, \"Look up\"",
"paperclip" => "A metal paperclip in your right hand",
"paperclip2" => "A metal paperclip bent in half",
"mobile phone" => "Your mobile phone",
"mobile phone2" => "Your mobile phone. It looks undamaged.",
"mobile phone3" => "Your mobile phone. It works fine",
"mobile phone4" => "Your mobile phone. It has no signal",
"battery" => "The battery from your phone",

"key" => "A small metal key with reasonably sharp teeth",
"chair" => "The chair you're sitting on. The top right quarter is in reach",
"chair2" => "The chair you're sitting on. It has been cut up a bit",
"chair3" => "The chair you're sitting on. Foam has been removed",
"head" => "Your head. You'll be able to reach it now",
"ropes" => "The ropes that tie up your left arm and right elbow",
"hair" => "A lock of hair messily cut from your head",
"foam" => "A few clumps of soft light-coloured foam",
"fabric" => "A few short strips of red fabric",
);

%start_look_1 = (
"right pocket" => "It is truly your right pocket",
"left pocket" => "It is possibly maybe your left pocket",
"vomit" => "Presumably the last meal you ate. On the ground beside the chair you're seated on.",
"chair" => "The chair you are sitting on. The basic rectangular metal frame supports two padded blocks. Patchy thin red material covers its soft filling, most likely foam.",
"paper" => "1You angle it towards you, looking over your shoulder to see it. You see that there is some writing on it, but you find it hard to read it with it at your side. You angle your wrist and manage to flick it onto your lap. It's the wrong way up but you can read the letters easily. In the center of the page, all that is written is:

Look up

The letters are in normal print, in black biro. At the bottom right corner of the page, there is a small metal paperclip.",
"up" => "1You tilt your head back to look up at the ceiling. There's nothing there, just a white-painted, blank wall.",
"mobile phone" => "1You look down at the mobile phone in your hand at the side. It's your brand new flip-phone. You flip it open with your thumb. Nothing seems to be broken.",
"battery" => "A mobile phone battery at your side. One side is mostly blank with just the manufacturers logo printed in white text. The other side is covered with a sticker. The writing on the sticker is mostly too small to read, but you can make out \"Warning\" in bigger red text.",
"paperclip" => "A small metal paperclip in your right hand along with a battery. It looks new and in good shape.",
"head" => "You can't actually see your own head, but you know it definitely exists.",
"ropes" => "The rope is wrapped and tied to the chair the most around your chest and hips. Separate strands also tie your wrists and elbows to your side.",

"key" => "A small metal key that looks like your house key. On closer inspection it has something engraved onto it that wasn't there before. You need to see it closer to tell what it says. The metal teeth look sharp enough to cut through thin material.",
"metal shards" => "Sooty metal shards scattered around on the ground close to you. The largest are most near to you.",
"foam" => "Some foam.",
"fabric" => "Some fabric.",
"hair" => "Some hair.",

);

%lock_look_1 = (
"up" => "There is nothing there, just the blank, white ceiling.",
"paper" => "A piece of paper on your lap. Upside-down letters simply say, \"Look up\". At the bottom right corner of the page, there is a small metal paperclip.",
"paper2" => "3Paper on the ground near you. It's on its other side and now you can see that there is a lot more written on it. It's in shaadow and the light in the room is low. You can only read the very top of the page. It says something about a short circuit.",
"paper3" => "Paper on the ground near you. It's on its other side so you can see that there is a lot more written on it. It's in shadow so you can only read the very top of the page. It says something about a short circuit.",
"mobile phone" => "It's your brand new flip-phone. It looks like it should work, nothing seems damaged.",
"mobile phone2" => "It's your brand new flip-phone. It works.",
"mobile phone3" => "It's your brand new flip-phone. It's useless because it has no signal.",
"mobile phone4" => "It's your mobile phone face-down on the ground. Its back-panel is lying next to it on the ground. The phones battery is gone.",
"battery" => "A mobile phone battery in your right hand at your side along with the paperclip. One side side is mostly blank with just the manufacturers logo printed in white text. The other side is covered with a sticker. The writing on the sticker is mostly too small to read, but you can make out \"Warning\" which is in larger red text.",
"paperclip" => "A paperclip that has been straightenned and bent in two. It is in your right hand along with a battery.",

"chair" => "The now slightly charred chair you are sitting on. The basic rectangular metal frame supports two padded blocks. Patchy thin red material covers its soft filling, most likely foam. Without the ropes holding your right wrist, you are able to easily reach the top right quarter of the bottom block.",
"chair2" => "The slightly charred chair you are sitting on. The basic rectangular metal frame supports two padded blocks. Scratched and torn red material reveals the light coloured foam beneath.",
"chair3" => "The slightly charred chair you are sitting on. The basic rectangular metal frame supports two padded blocks. In the top right corner red material and some foam has been removed.",
"ropes" => "The ropes that tie your body to the chair. The rope for your right wrist is burnt and frayed and no longer holds the wrist secure.",
);

@hash = (
"inventory",
"look",
"look_1",
);

%inventory = %start_inventory;
%look = %start_look;
%look_1 = %start_look_1;

1;