extends PanelContainer

const GameDisplay = preload("res://scenes/terminal_return_display.tscn")
const response = preload("res://scenes/response.tscn")


@onready var game_area = $MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer
@onready var scroll = $MarginContainer/VBoxContainer/ScrollContainer
@onready var scrollbar = scroll.get_v_scroll_bar()

var terminal_panel_hidden = true


func _ready() -> void:
	scrollbar.connect("changed", on_scroll)
	if terminal_panel_hidden:
		self.visible = false


func on_scroll():
	scroll.scroll_vertical  = scrollbar.max_value

func get_input():
	if Input.is_action_pressed("terminal") && GlobalPlayerData.terminal_activated:
		display_panel()
		$MarginContainer/VBoxContainer/HBoxContainer/LineEdit.grab_focus()


func _process(delta: float) -> void:
	get_input()


func display_panel():
	if terminal_panel_hidden:
		terminal_panel_hidden = false
		self.visible = true



func _on_texture_button_pressed() -> void:
	self.visible = false
	terminal_panel_hidden = true
	Global.input_focus_regrab = true


func _on_line_edit_text_submitted(new_text: String) -> void:
	if new_text.is_empty():
		return
		
	var game = GameDisplay.instantiate()
	var response = terminal_commands(new_text)
	manage_game_info(game)
	game.set_text(new_text, response)


func terminal_commands(input: String):
	var words = input.split(" ", false)
	
	if words.size() == 0:
		return "Sorry, I can't do that."
		
	var first_word = words[0].to_lower()
	var second_word = ""
	var third_word = ""
	if words.size() > 1:
		second_word = words[1].to_lower()
	if words.size() > 2:
		third_word = words[2].to_lower()
	match first_word:
		"name":
			set_player_name()
			return "Setting your name in the system, after you submit, you can type VERIFY to check name"
		"verify":
			return "According to the system, your name is: " + GlobalPlayerData.player_name
		"activate":
			return activate_machinery(second_word)
		"manipulator":
			if GlobalPlayerData.machinery_activated:
				return activate_manipulator(second_word, third_word)
			else:
				return "ERROR: The MACHINERY is not ACTIVATED."
		"crane":
			if GlobalPlayerData.machinery_activated:
				return move_crane(second_word, third_word)
			else:
				return "ERROR: The MACHINERY is not ACTIVATED."
		"clear":
			return clear_terminal()
		_:
			return "Invalid Terminal Command, try again"

func manage_game_info(response):
	game_area.add_child(response)


func set_player_name():
	$NameEntry.visible = true


func clear_terminal():
	var entries_to_remove = game_area.get_child_count()
	for i in range(entries_to_remove):
		game_area.get_child(i).queue_free()
	return ""


func activate_machinery(second_word):
	if second_word == "":
		return "Error: Command requires a parameter. Activate what?"
	elif second_word == "machinery":
		GlobalPlayerData.machinery_activated = true
		return "The MACHINERY has been ACTIVATED."
	else:
		return "Error: unknown command, action aborted."


func activate_manipulator(second_word, third_word):
	if second_word == "":
		return "Error: The MANIPULATOR requires one or more commands to operate."
	elif second_word == "grab":
		if third_word == "tools":
			GlobalPlayerData.tools_grabbed = true
			return "Manipulator activated, TOOLS now ready for use."
		else:
			return "Error: Faulty command, MANIPULATOR failed to respond. GRAB what?"
	elif second_word == "install":
		if third_word == "":
			return "Error: MANIPULATOR requires additional command, INSTALL what?"
		if third_word == "parts":
			if GlobalPlayerData.parts_moved:
				GlobalPlayerData.parts_installed = true
				return "Installing PARTS in Robot named " + GlobalPlayerData.player_name
			elif !GlobalPlayerData.parts_moved:
				return "Error: No PARTS found to install."
		if third_word == "limbs":
			if GlobalPlayerData.limbs_moved:
				GlobalPlayerData.has_limbs = true
				GlobalPlayerData.limbs_attached = true
				return "Installing LIMBS in Robot named " + GlobalPlayerData.player_name
			elif !GlobalPlayerData.limbs_moved:
				return "Error: No LIMBS found to install."
		else:
			return "Error: Unrecognized command, MANIPULATOR failed to respond."
	else:
		return "Error: Command not recognized, try again."


func move_crane(second_word, third_word):
	if second_word == "":
		return "The CRANE requires a command to operate."
	elif second_word == "activate":
		GlobalPlayerData.crane_activated = true
		return "CRANE activated, ready to MOVE."
	
	if second_word == "move" && GlobalPlayerData.crane_activated:
		if third_word == "":
			return "Error: CRANE requires additional command. MOVE what?"
		
		if third_word == "parts":
			if !GlobalPlayerData.parts_moved:
				GlobalPlayerData.parts_moved = true
				return "PARTS MOVING to Robot for INSTALL."
			if GlobalPlayerData.parts_moved:
				return "PARTS already in postion for INSTALL."
				
		if third_word == "limbs":
			if !GlobalPlayerData.limbs_moved:
				GlobalPlayerData.limbs_moved = true
				return "LIMBS MOVING to Robot for INSTALL."
			if GlobalPlayerData.limbs_moved:
				return "LIMBS already in postion for INSTALL."
		
		else:
			return "Unrecognized parameter, CRANE failed to respond."
