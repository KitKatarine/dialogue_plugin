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
	# Make sure there isn't a dialogue box already in the tree
	var findme = find_child("Dialogue", true, false)
	if findme == null:
		# Create a new dialogue box to add
		var new_dialogue = dialogue.instantiate()
		# These options are called BEFORE the node is added to the tree.
		# This is all the text we want to display; If your dialogue has options, that should be the end of the textbox.
		new_dialogue.add_new_text(["Hello I am a textbox! I'll teach you how to use this textbox, if you want", "Learn how to use textboxes?"])
		# The options we want to offer the player, as a string array
		new_dialogue.add_dialogue_options(["Sure", "No way"])
		# Connect the signal to this object - and make the receiving function.
		new_dialogue.option_button_pressed.connect(_on_branching_dialogue_pressed)
		# Finally, add the dialogue box to the tree
		add_child(new_dialogue)

# This is the receiving function, it will get whatever option was clicked.
func _on_branching_dialogue_pressed(node, option, branch_level):
	# Delete the old textbox
	var deleteme = find_child(node.name, true, false)
	deleteme.queue_free()
	# once again, instantiate the new box
	var new_dialogue = dialogue.instantiate()
	# Match branch_level
	match branch_level:
		0:
			match option:
				"Sure":
					new_dialogue.add_new_text(["Great! You're already halfway there!", "Here's a second branch to demonstrate how dialogue can have nested branching paths!", "Do you understand?"])
					
					new_dialogue.add_dialogue_options(["Yes", "Bruh"])
					# Increase the counter so this function knows where you want to link these responses to.
					# In this case, it's 1. You'll see below we're matching branch_level 1 with these options.
					new_dialogue.current_dialogue_branch = 1
					# For additional branching paths, don't forget to connect the signal again
					new_dialogue.option_button_pressed.connect(_on_branching_dialogue_pressed)
				"No way":
					new_dialogue.add_new_text(["Oh, okay..", "[You've made the Godot Robot sad. -2 programmer points.]"])
		1: 
			match option:
				"Yes":
					new_dialogue.add_new_text(["Wahoo! That's it, it works. I'm done. Fantastic."])
				"Bruh":
					new_dialogue.add_new_text(["Listen, writing a comprehensive tutorial is hard! There are so many variables, and people comprehend things differently."])

	add_child(new_dialogue)
					
# You can also add flags for whatever globals you have in your game, depending on what options were picked! 
