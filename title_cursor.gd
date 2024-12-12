extends Label


var speed = 5
var fade = false

var time = 0
var sinTime = 0


func cursor_blink():
	if !fade:
		if sinTime > 0:
			self.visible = true
		else:
			self.visible = false
	else:
		self.visible = true
		self.modulate.a = sinTime
		
func _process(delta: float) -> void:
	time += delta
	sinTime = sin(time * speed)
	cursor_blink()
