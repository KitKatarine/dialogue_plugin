![A light blue text bubble with three white lines. Below, the text "Kit's Simple Dialogue" in the same light blue color.](/graphic.svg)

# Kit's Simple Dialogue
### Version 1.0.0
A simple file for simple textboxes. Proudly made without generative AI.

## Table of Contents:
+ [What is this](https://github.com/KitKatarine/dialogue_plugin/blob/main/README.md#what-is-this)
+ [Getting Started](https://github.com/KitKatarine/dialogue_plugin/blob/main/README.md#getting-started)
+ [How To Use](https://github.com/KitKatarine/dialogue_plugin/blob/main/README.md#how-to-use)
+ [Notes and Other Functions](https://github.com/KitKatarine/dialogue_plugin/blob/main/README.md#notes-and-other-functions)
+ [License](https://github.com/KitKatarine/dialogue_plugin/blob/main/README.md#license)

## What is this?
This is a dialogue/textbox prefab that creates a textbox, displays text, and sorts out any dialogue options into neat little buttons. Perfect for visual novels, RPGs, or other dialogue-based games. While it certainly is not the most feature rich or robust system, with this, you can get started with making textboxes quickly and easily. 

[<Top>](https://github.com/KitKatarine/dialogue_plugin/blob/main/README.md#kits-simple-dialogue)

## Getting Started
To get the dialogue system in your project:
  Download the "main" branch .zip file
  Extract somewhere (such as your default Download folder)
  Put the "dialogue-system" folder in your project's res:// directory

Initial setup:
  Go into your project's InputMap and create a new input called "interact"; You can change this later, but for quick-start this is what I recommend. Assign any key to it - I chose "E", but you can do whatever is comfortable.
  
[<Top>](https://github.com/KitKatarine/dialogue_plugin/blob/main/README.md#kits-simple-dialogue)

## How To Use
### ADDING THE DIALOGUE SCENE
The dialogue will be called by the node you're interacting with, as opposed to some omnipotent autoload. Therefore, in the GDScript file of your "parent" node, you will want to add the following:

`var dialogue = preload("res://Dialogue_System/dialogue.tscn");`

This will preload the scene that holds all the bits and bobs of the Dialogue handler. 
When you want to make a dialogue textbox, you can then use instantiate() to add the scene to your parent scene.

`var new_dialogue = dialogue.instantiate();`

** NOTE: It is recommended that you check first for instances of the dialogue scene and clear them via queue_free(). **

You can then call the dialogue function add_new_text(), which takes a PackedStringArray - an array of strings. If you want to put branching dialogue choices, you will want your branch to end on the dialogue that shows the choices. Then, you can call add_dialogue_options(), which also is a PackedStringArray.
```
new_dialogue.new_dialogue.add_new_text([
"This is the first text box",
"This is the second text box"
])

new_dialogue.add_dialogue_options([
"Option 1",
"Option 2",
"Option 3"
])
```
Finally, connect the dialogue signal option_button_pressed to a function of your choosing - this will handle your dialogue options when a button is pressed. If your dialogue does not have options, you do not need to connect the signal.

`new_dialogue.option_button_pressed.connect(_on_branching_dialogue_pressed)`

Finally, add the newly set up dialogue as a child to the scene

`add_child(new_dialogue)`

[<Top>](https://github.com/KitKatarine/dialogue_plugin/blob/main/README.md#kits-simple-dialogue)

### SETTING UP THE RECEIVING FUNCTION
Now that you've set up adding the textbox, you can now set up receivers for your options, if you chose to use them. Make your receiving function, which will be passing the node information, the option chosen, and the branch that your dialogue is currently on.

`func _on_branching_dialogue_pressed(node, option, branch_level):`

** NOTE: Again, you will want to find and clear out any old dialogue boxes, if any. This is made easier with the node argument, which will allow you to easily use find_child(node.name, true, false)

Instantiate a new dialogue as before

`var new_dialogue = dialogue.instantiate()`

Then, you can set up nested match statements; first, for the branch level of your dialogue, and then within it, for your options. 
Within the options, you can then set up further dialogue as before
```
 match branch_level:
   0:
     match option:
       "Option 1":
         new_dialogue.new_dialogue.add_new_text(["You've chosen the first option!"])
       "Option 2":
         new_dialogue.new_dialogue.add_new_text(["You've chosen the second option!"])
       "Option 3":
         new_dialogue.new_dialogue.add_new_text(["You've chosen the third option!"])
```
Branch level always starts at 0. To add further dialogue options, as before, you simply follow the same steps
```
 match branch_level:
   0:
     match option:
       "Option 1":
         new_dialogue.new_dialogue.add_new_text(["You've chosen the first option!"])
       "Option 2":
         new_dialogue.new_dialogue.add_new_text(["You've chosen the second option!"])
       "Option 3":
         new_dialogue.new_dialogue.add_new_text(["You've chosen the third option, which has further options to choose!"])
         new_dialogue.add_dialogue_options(["Option 1","Option 2"])
         new_dialogue.option_button_pressed.connect(_on_branching_dialogue_pressed)
         new_dialogue.current_dialogue_branch = 1
   1:
     match options:
       "Option 1":
         new_dialogue.new_dialogue.add_new_text(["You've chosen the first option!"])
       "Option 2":
         new_dialogue.new_dialogue.add_new_text(["You've chosen the second option!"])
 add_child(new_dialogue)
```
You will notice in branch_level 0, option 3, that there is a new setting: current_dialogue_branch. This determines where your option goes in the resulting return. You can point your dialogue wherever, so long as there is a returning match.

** NOTE: For further safety, consider adding a default dialogue option to fall back on. In GDScript, this is wriiten as
```
> match foo:
>   _:
>     print("bar")
```
Where "foo" is your match statement, and "bar" is the thing you want to print. No one ever explains what foo and bar is, honestly - they're just stand-ins. Replace them with whatever you need.

At this point, your dialogue SHOULD be set up and running, if I've outlined everything correctly.

[<Top>](https://github.com/KitKatarine/dialogue_plugin/blob/main/README.md#kits-simple-dialogue)

# Notes and Other Functions

+ The Dialogue prefab also comes with the signals `text_advanced(text)` and `text_finished`. If you wish to make use of these signals, they must also be connected to your calling node in the same manner as `option_button_pressed`. 

+ You may replace the default `Button.new()` behavior with instantiating your own button prefab. You may need to adjust some values.

+ When clearing previous Dialogue instances, I use `find_child(node.name, true, false)` as for some reason in my test scene it does not count as being "owned" by any one node, despite being in the tree. This may be something I fix in the future.

+ This branch also comes with a test scene; you can see how all the pieces fit together through METICULOUSLY commented code. I tried to make sure everything was explained, but I am a human, and humans make mistakes. Feel free to adjust the code to your liking. Heck, make it an actual plugin (If you do, please tag me on Bluesky @gm-kitkatarine.bsky.social I'm very stupid and have no patience for that sort of stuff.)

[<Top>](https://github.com/KitKatarine/dialogue_plugin/blob/main/README.md#kits-simple-dialogue)

# License

This code uses a CREATIVE COMMONS license. Please read the [full license](/LICENSE) for details.

Additionally, while a CC0 license does not prohibit the use of generative AI to modify or otherwise iterate upon the source, I prohibit the use of this code for use with generative AI models. Iterations, forks, and/or copies made with any generative AI agents such as; Claude, ChatGPT, and others, are prohibited by the creator and any forks, iterations, copies, or other made with such models are not reflective of the original source code.

[<Top>](https://github.com/KitKatarine/dialogue_plugin/blob/main/README.md#kits-simple-dialogue)
