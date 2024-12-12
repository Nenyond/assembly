extends LineEdit


func _process(delta: float) -> void:
	get_input()

func get_input():
	if Input.is_action_pressed("enter"):
		clear()
