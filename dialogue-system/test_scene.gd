extends Node

# This scene goes over how to use the Dialogue Scene.
#
# In this scene, the player will press a button and read a textbox containing: 
# - A standard text
# - A dialogue option
# - Branching paths depending on which option was chosen.

## The dialogue scene we will be using.
var dialogue = preload("res://Dialogue_System/dialogue.tscn")


func _on_texture_button_pressed() -> void:
	# Create a new dialogue box to add
	var new_dialogue = dialogue.instantiate()
	# These options are called BEFORE the node is added to the tree.
	# This is all the text we want to display; If your dialogue has options, that should be the end of the textbox.
	new_dialogue.add_new_text(["Hello I am a textbox! I'll teach you how to use this textbox, if you want", "Learn how to use textboxes?"])
	# The options we want to offer the player, as a string array
	new_dialogue.add_dialogue_options(["Sure", "No way", "Option 3"])
	# Connect the signal to this object - and make the receiving function.
	new_dialogue.option_button_pressed.connect(_on_branching_dialogue_pressed)
	# Finally, add the dialogue box to the tree
	add_child(new_dialogue)

# This is the receiving function, it will get whatever option was clicked.
func _on_branching_dialogue_pressed(option):
	var deleteme = find_child("Dialogue", true, false)
	deleteme.queue_free()
	print(option)
	var new_dialogue = dialogue.instantiate()
	match option:
		"Sure":
			new_dialogue.add_new_text(["Great! You're already halfway there!"])
			add_child(new_dialogue)
		"No way":
			new_dialogue.add_new_text(["Fuck off then."])
			add_child(new_dialogue)
		"Option 3":
			new_dialogue.add_new_text(["Haha awesome."])
			add_child(new_dialogue)
