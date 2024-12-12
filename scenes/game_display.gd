extends VBoxContainer


func set_text(input: String, response: String):
	$history.text = " > " + input
	$response.text = response
