#!/usr/bin/perl
use warnings;

%c = (
"bg" => "\e[1;40m",		#background
"av" => "\e[1;32;40m",	#action/value
"avu" => "\e[1;36;40m",	#use action/value
"avuu" => "\e[1;35;40m",#use use action/value
"l" => "\e[0;32;40m",	#> (line starter)
"lu" => "\e[1;34;40m",	#> (use line starter)
"luu" => "\e[0;35;40m",	#> (use use line starter)
"t" => "\e[1;33;40m",	#title
"t1" => "\e[32m",		#title 1 (Ajar ASCII)
"t2" => "\e[30m",		#title 2 (Ajar ASCII box)
"n" => "\e[0;37;40m",	#narrative
"f" => "\e[0;33;40m",	#first person
"ooc" => "\e[1;37;40m",	#out of context
"e" => "\e[1;31;40m",	#error
"sav" => "\e[1;33;40m",	#saves
"s" => "\e[1;32;40m",	#success
"w" => "\e[1;37;40m",	#welcome
"i" => "\e[1;34;40m",	#item (use line starter)
"a" => "\e[0;35;40m",	#act (use use line starter)
"lgt" => "\e[46;37m",	#cutting checker bg light
"drk" => "\e[44;37m",	#cutting checker bg dark
"sel" => "\e[41;37m",	#cutting bg selection
#0 Reset (unbold)
#1 Bold

#30 Black		#34 Blue
#31 Red			#35 Magenta
#32 Green		#36 Cyan
#33 Yellow		#37 White
);

%start_actions_0 = ("look" => "Open your eyes...");
%lock_actions_0 = (0,0); delete $lock_actions_0{0};
%actions = ("title!" => "Actions", %start_actions_0);
%lock_actions_1 = (
"combine" => "Merge in-reach items together. Usually reversible with separate",
"look" => "See not-in-reach items or examine a specified item",
"reach" => "See in-reach items or reach for a specified item",
"separate" => "Pull apart an in-reach item. Usually reversible with combine",
"use" => "Use an in-reach item for any known function",
);

%start_actionhelp = (
"help" => "Without a value: Shows fundamental help on the game
With a value: Shows detailed help on the value if it is an Action or Command
Values: an Action or Command (optional)",
"look" => "Opens your eyes
This will begin the game
Values: N/A",
"actions" => "Shows the actions you can currently perform
Lists them in alphabetical order
Values: N/A",
"commands" => "Shows various commands you can use
Lists them in alphabetical order
Values: N/A",
"save" => "Saves where you are in the game so that you can load it later
If you save in a slot that already has a saved game, you will overwrite it
Values: the slot you want to save in (1 to 9)
Note: if the value is omitted, you will be shown the saves you have, then asked
for the slot number

See also:
$c{av}delete
load",
"load" => "Loads to where you were in a saved game
Values: the save you want to load (1 to 9)
Note: if the value is omitted, you will be shown the saves you have, then asked
for the slot number

See also:
$c{av}delete
save",
"delete" => "Deletes a saved game
Values: the save you want to delete (1 to 9)
Note: if the value is omitted, you will be shown the saves you have, then asked
for the slot number

See also:
$c{av}load
save",
"exit" => "Exits the game
Make sure you have saved any progress before doing this
Values: N/A",
"new" => "Start a new game
This is the equivalent of closing the game and launching it again
Make sure you have saved any progress before doing this
Values: N/A",
"clear" => "Clears all text on the game screen
This does not start a new game, it merely cleans up
Values: N/A",
"keys" => "Shows some useful information on the game.
Also lists some keys that will help you play with more ease.
Values: N/A",
"combine" => "Specify any amount of items you have in your inventory.
If you know how to combine them, they will be combined.
This consumes the items but usually produces a new item.
The process can usually be reversed with $c{av}separate.
$c{ooc}Values: 2 or more items in your inventory

See also:
$c{av}separate",
"reach" => "Without a value: Lists items you have in arms-reach
With a value: Reach for the specified item
If you can reach it, it will usually be added to your inventory.

Values: An item not-in-reach (optional)

See also:
$c{av}look",
"separate" => "Specify an item in your inventory to separate
If you know how to separate it, it will be separated.
This consumes the item but can produce many more.
The process can usually be reversed with $c{av}combine.
$c{ooc}Values: An item in your inventory

See also:
$c{av}combine",
"use" => "Specify an item that you have in your inventory.
If you know any way to use the item, the use system will start.
The use system is like the normal game but with it's own set of actions.
The actions list will be shown straight away, and you can see it again the usual way.
As well as those actions, $c{av}clear $c{ooc}and $c{av}exit $c{av}can also be used.
Values: An item in your inventory",
"alias" => "An alias is a word you can set to use in place of an Action/Command
They are saved separately from saves, so they are carried between games
Aliases will not function in the $c{av}use$c{ooc} system
Without values: List all the aliases set
With 1 value: Delete the specified alias
With 2 values: 1 value must be an Action/Command, the other must not
The Action/Commands alias will be set to the non-Action/Command value
For example: $c{l}>$c{av}alias look,l $c{ooc} will allow you to use \"l\" in place of $c{av}look
$c{ooc}An Action/Command can have more than 1 alias but every alias must be unique
Both values should be 1 word, they will be made into 1 word if not",
);

%lock_actionhelp = (
"look" => "Without a value: Views the items you can see that aren't in your inventory
Lists them in alphabetical order
The inventory can be viewed with $c{l}>$c{av}look inventory$c{ooc}
This will show the same thing as $c{l}>$c{av}reach$c{ooc}
With a value: Views the specific item (an item from $c{av}look $c{ooc}or $c{av}reach$c{ooc})
Provides a full description of the item
Values: an item name (optional)

See also:
$c{av}reach",
);

%commands_0 = (
"commands" => "List all commands",
"actions" => "List all available actions",
"exit" => "Exit Ajar",
"clear" => "Clear away all text on the screen",
"new" => "Start a new game",
"keys" => "List basic info on the games keys",
);
%commands_1 = (
"help" => "List basic help or get help on a specified Action/Command",
"load" => "Load a saved game. Specify a slot from 1 to 9",
"save" => "Save your progress. Specify a slot from 1 to 9",
"delete" => "Delete a saved game. Specify a slot from 1 to 9",
"alias" => "See, delete or create aliases. 0, 1 or 2 values respectively",
);
%commands = ("title!" => "Commands", %commands_0, %commands_1);

%help = (
"title!" => "Help",
"1Actions" => "Actions are performed by the character",
"2Commands" => "Commands are not character performed. They are like $c{av}save$c{ooc}/$c{av}load",
"3 How?" => "An Action or Command is the first word typed after the $c{l}>",
"4Values" => "Words entered after the Action or Command are called Values",
"5 Also" => "Values can be multiple words, separate values with a comma",
"6 Example" => "$c{l}>$c{av}combine flour,white sugar,milk $c{ooc}(combine Action with 3 values)",
"7Help" => "The $c{av}help$c{ooc} Command can take any Action or Command as a value",
"8 Example" => "$c{l}>$c{av}help look$c{ooc} (displays help on the look Action)",
"9What now?" => "To begin; $c{av}commands$c{ooc} brings up a list of commands you can use
",
"That's everything you need to know.", ""
);

%keys = (
"title!" => "Keys",
"1Only alphabetical letters, numbers 1-9, spaces, and commas are recognised by
this game. Every other letter is treated as if it wasn't there. The game is
entirely case insensitive, uppercase is converted to lowercase. The following
is some information that will be mostly useless.
", "",
"Left/right" => "Move the cursor left and right.",
"Up/down" => "Move up/down through previously entered lines",
"Enter" => "Submit a line",
"Backspace" => "Remove the character immediately before the cursor",
"Delete" => "Remove the character surrounded by the cursor",
"Escape" => "Remove every character on the line",
"Ctrl+C" => "Interrupt signal will enter a line but not submit it.",
"Insert" => "Toggle between insert character and type over character",
"Alt+Enter" => "Toggle full-screen (for most systems)",
);

@look = (
"$c{f}<dream>
$c{n}
Your eyes flick open before the dream is finished; you remember only the end of it. You are in a room, seated on a chair. Your vision is blurry; you blink a few times in pain until it is restored. You are very tired and have a sharp headache. Parts of your body are numb. Your head flutters around as you groggily look about the room. Despite this, you don't take any of the sights in; your attention is instead focussed on a numbed pain mid-way up your legs. You peer down at them, staring in horror when you realise that your legs end just before where your knees would be. Your blood stained trousers are torn and knotted to restrain the stubs. Your head suddenly jerks to the side. You throw up. You then continue to retch, bile stinging at your throat. You close your eyes tightly as they water, leaning back and letting your head tilt to one side. Keeping your eyes closed, you begin to groan in agony and grief and continue to do so for minutes.",

"You gather the willpower to open your eyes again. You look around the room. You see that the door to the room is open, but only slightly. You struggle on the chair but the ropes are tied firmly. The chair also seems to be bolted to the ground.",
);

unshift @hash, (
"actionhelp",
"actions_0",
"actions_1",
);

%actionhelp = %start_actionhelp;
%actions_0 = %start_actions_0;
%actions_1 = %start_actions_1;

1;