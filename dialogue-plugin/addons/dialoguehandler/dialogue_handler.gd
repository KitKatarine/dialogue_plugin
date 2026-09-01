@tool
extends EditorPlugin

func _enable_plugin() -> void:
	# Add autoloads here.
	pass;

func _disable_plugin() -> void:
	# Remove autoloads here.
	pass;


func _enter_tree() -> void:
	# Initialization of the plugin goes here.
	add_custom_type("Dialogue", "Control", preload("res://addons/dialoguehandler/dialogue_node.gd"), preload("res://addons/dialoguehandler/icon.png"))


func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	remove_custom_type("Dialogue")
