extends Control




func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")


func _on_credits_button_pressed() -> void:
	pass # Replace with function body.


func _on_git_hub_button_pressed() -> void:
	OS.shell_open("https://github.com/Nenyond/assembly")
