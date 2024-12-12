extends MarginContainer

var panel_hidden = true

func _ready() -> void:
	if panel_hidden:
		self.visible = false

func get_input():
	if Input.is_action_pressed("character panel"):
		display_panel()


func _process(delta: float) -> void:
	get_input()
	manage_player_name()

func display_panel():
	if panel_hidden:
		panel_hidden = false
		self.visible = true


func _on_texture_button_pressed() -> void:
	panel_hidden = true
	self.visible =  false
	Global.input_focus_regrab = true
	

func manage_player_name():
	$PanelContainer/MarginContainer/VBoxContainer/PlayerName.text = GlobalPlayerData.player_name
	
