extends MarginContainer

var panel_hidden = true

@onready var player = $"../../Player"
@onready var storage = $PanelContainer/MarginContainer/VBoxContainer/storage/StorageContents

func _ready() -> void:
	if panel_hidden:
		self.visible = false

func get_input():
	if Input.is_action_pressed("character panel"):
		display_panel()


func _process(_delta: float) -> void:
	get_input()
	manage_player_name()
	manage_parts()

func display_panel():
	if panel_hidden:
		panel_hidden = false
		self.visible = true


func _on_texture_button_pressed() -> void:
	panel_hidden = true
	self.visible =  false
	Global.input_focus_regrab = true
	

func manage_parts():
	if GlobalPlayerData.parts_installed:
		$PanelContainer/MarginContainer/HBoxContainer/PartsDisplay.text = "Has PARTS"
	else:
		$PanelContainer/MarginContainer/HBoxContainer/PartsDisplay.text = "No PARTS"
		
	if GlobalPlayerData.has_limbs or GlobalPlayerData.limbs_attached:
		$PanelContainer/MarginContainer/HBoxContainer/LimbDisplay.text = "Has LIMBS"
	else:
		$PanelContainer/MarginContainer/HBoxContainer/LimbDisplay.text = "No LIMBS"


func manage_player_name():
	$PanelContainer/MarginContainer/VBoxContainer/PlayerName.text = GlobalPlayerData.player_name
	storage.text = player.get_inventory()
	
