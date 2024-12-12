extends PanelContainer


func _ready() -> void:
	self.visible = false


func _on_texture_button_pressed() -> void:
	self.visible = false


func _on_name_edit_text_submitted(new_text: String) -> void:
	GlobalPlayerData.player_name = new_text
	
	
