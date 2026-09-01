extends Control


## How fast the text should be printed (Default: 1) 
## [br]Higher numbers means slower text.
@export var text_speed:int = 1;

## How long to wait before the player can progress the text (Default:1.0) 
## [br]Higher numbers mean longer waits before player can advance to the next textbox
@export var input_delay:float = 1.0;

## What we want to show the player when it's time to go to the next slide (index 0: next slide, index 1: close textbox)
var progress_indicator:PackedStringArray= [">", "END"]
## The lines that we want to display
var text_array:PackedStringArray = [];
## The current line we want read
var current_line:int = 0
## The total lines in the array
var total_lines:int = 0

## The current number of characters in the string to draw
var current_character:int = 0;

## When we have advanced the text, either through a button press or through a timer.timeout()
signal text_advanced(text)
## When we have finished reading through all the text, and there is no more to display
signal text_finished

signal option_button_pressed(option)

@onready var text_display:Node = $textbox_graphic/MarginContainer/textbox_text

func _ready() -> void:
	

	# Assign the passed text to the textbox
	text_display.text = text_array[current_line]
	
	# Get the total number of lines in our array
	total_lines = text_array.size()-1
	
	# Set visible characters to 0
	text_display.visible_characters = current_character
	
	# Read the first line
	read_line(current_line)
	
	# begin our draw characters
	draw_chars();
	
func _process(_delta: float) -> void:
	# Set our visible chars to the current character
	text_display.visible_characters = current_character
	
	# For vertical buttons, use VboxContainer and this code
	$textbox_graphic/dialogue_options.position.y = get_viewport_rect().size.y -( $textbox_graphic.size.y + $textbox_graphic.position.y) - $textbox_graphic/dialogue_options.size.y
	
	if Input.is_action_just_pressed("ui_copy"):
		print(get_tree_string_pretty())
		
	# If we have just hit a button to advance the text
	# WARNING: Do not use the default ui_accept for this!!!!! Make your own in the Input Map!!!!!
	if $textbox_graphic/progress_text.visible == true:
		if Input.is_action_just_pressed("interact"):
			$textbox_graphic/progress_text.visible = false
			text_advanced.emit(text_array[current_line])
			# If our current line == total number of lines
			if current_line == total_lines:
				# Emit our text_finished signal and delete the node
				# If the textbox also pauses the character from moving, reset it here.
				text_finished.emit()
				queue_free()
			else:
				# Set our visible chars to 0 and read next line
				current_line +=1 
				print(current_line)
				print(text_array[current_line])
				current_character = 0
				read_line(current_line)
				draw_chars()

func read_line(line):
	# if our current line isn't our total lines
	text_display.text = text_array[line]

func draw_chars():
	# While we haven't drawn the whole string yet
	while current_character != text_array[current_line].length():
		# Create a timer that uses our text speed, and then increment current_character
		await get_tree().create_timer(text_speed*0.01).timeout
		current_character += 1
	if current_character == text_array[current_line].length():
		await get_tree().create_timer(input_delay).timeout
		if current_line != total_lines:
			$textbox_graphic/progress_text.text = progress_indicator[0]
			$textbox_graphic/progress_text.visible = true
		else:
			if $textbox_graphic/dialogue_options.get_child_count() > 0:
				for i in $textbox_graphic/dialogue_options.get_children():
					i.visible = true
			else:
				$textbox_graphic/progress_text.text = progress_indicator[1]
				$textbox_graphic/progress_text.visible = true
		
		
func add_new_text(txt:PackedStringArray):
	text_array = txt
	
func add_dialogue_options(options:PackedStringArray):
	for i in options.size():
		var button = Button.new()
		button.name = options[i]
		button.text = options[i]
		button.visible = false
		button.pressed.connect(_on_dialogue_button_pressed.bind(button.name))
		$textbox_graphic/dialogue_options.add_child(button)
		
func _on_dialogue_button_pressed(arg):
	option_button_pressed.emit(arg)
