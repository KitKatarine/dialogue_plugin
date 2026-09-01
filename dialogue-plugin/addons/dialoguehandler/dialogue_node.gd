@tool
extends Control

## How fast the text should be printed (Default: 1)
@export var text_speed:int = 1;
## How long to wait before the player can progress the text (Default:1)
@export var input_delay:float = 1.0;

## The lines that we want to display
var text_array:PackedStringArray = [];
## The current line we want read
var current_line:int = 0
## The total lines in the array
var total_lines:int = 0

## The current number of characters to draw (EXPERIMENTAL)
var current_character:int = 0;

## When we have advanced the text, either through a button press or through a timer.timeout()
signal text_advanced(text)
## When we have finished reading through all the text, and there is no more to display
signal text_finished

@onready var text_display:Node = $dialogue_graphic/textbox_margin/text

func _ready() -> void:
	text_array = ["This is some test text to ensure that the draw function works as intended. This should be commented out when done testing."]
	text_display.text = text_array[current_line]
	total_lines = text_array.size()-1
	text_display.visible_characters = current_character
	
	read_line(current_line)
	
func _process(delta: float) -> void:
	pass;
	
func read_line(line):
	print("%s: Reading new line" % name)
	current_line = line

	if line != total_lines:
		text_display.text = text_array[line]
		await get_tree().create_timer(input_delay).timeout
