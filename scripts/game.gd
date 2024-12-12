extends Control

const response = preload("res://scenes/response.tscn")
const GameDisplay = preload("res://scenes/game_display.tscn")
@export var memory_lines:int = 2

@onready var parser = $TextParser
@onready var game_area = $TextureRect/MarginContainer/VBoxContainer/game_output/MarginContainer/ScrollContainer/VBoxContainer
@onready var scroll = $TextureRect/MarginContainer/VBoxContainer/game_output/MarginContainer/ScrollContainer
@onready var scrollbar = scroll.get_v_scroll_bar()
@onready var input = $TextureRect/MarginContainer/VBoxContainer/player_input/HBoxContainer/input
@onready var location_manager = $LocationManager


func _ready() -> void:
	scrollbar.connect("changed", on_scroll)
	parser.connect("response_generated", on_response_generated)
	parser.connect("clear_responses_generated", on_clear_responses_generated)
	parser.initialize(location_manager.get_child(0))
	input.grab_focus()


func _process(delta: float) -> void:
	focus_controller()


func on_scroll():
	scroll.scroll_vertical  = scrollbar.max_value


func _on_line_edit_text_submitted(new_text: String) -> void:
	if new_text.is_empty():
		return
		
	var game = GameDisplay.instantiate()
	var response = parser.process_command(new_text)
	manage_game_info(game)
	game.set_text(new_text, response)


func on_response_generated(response_text: String): 
	var message = response.instantiate()
	message.text = response_text
	manage_game_info(message)


func manage_game_info(response):
	game_area.add_child(response)
	manage_game_history()


func manage_game_history():
	if game_area.get_child_count() > memory_lines:
		var entries_to_remove = game_area.get_child_count() - memory_lines
		for i in range(entries_to_remove):
			game_area.get_child(i).queue_free()
			

func on_clear_responses_generated():
	print("clear command received")
	var entries_to_remove = game_area.get_child_count()
	for i in range(entries_to_remove):
		game_area.get_child(i).queue_free()


func focus_controller():
	if Global.input_focus_regrab:
		input.grab_focus()
		Global.input_focus_regrab = false
