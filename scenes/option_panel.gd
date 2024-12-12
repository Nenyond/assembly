extends PanelContainer

@onready var MasterVolume = AudioServer.get_bus_index("Master")
@onready var MusicVolume = AudioServer.get_bus_index("Music")
var option_panel_hidden = true


func _ready() -> void:
	if option_panel_hidden:
		self.visible = false


func get_input():
	if Input.is_action_pressed("options"):
		display_panel()


func _process(delta: float) -> void:
	get_input()


func display_panel():
	if option_panel_hidden:
		option_panel_hidden = false
		self.visible = true


func _on_texture_button_pressed() -> void:
	option_panel_hidden = true
	self.visible =  false
	Global.input_focus_regrab = true


func _on_master_volume_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(MasterVolume, linear_to_db(value))


func _on_music_volume_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(MusicVolume, linear_to_db(value))
