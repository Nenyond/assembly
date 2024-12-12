extends Node

signal response_generated(response_text)
signal clear_responses_generated

var current_location = null

@onready var terminal_access = $"../CanvasLayer/TerminalPanel"

func initialize(starting_location):
	change_location(starting_location)


func process_command(input:String) -> String:
	var words = input.split(" ", false)
	
	if words.size() == 0:
		return "Sorry, I can't do that."
		
	var first_word = words[0].to_lower()
	var second_word = ""
	if words.size() > 1:
		second_word = words[1].to_lower()
	match first_word:
		"go":
			return go(second_word)
		"help":
			return help()
		"take":
			return take()
		"look":
			return look(second_word)
		"interact":
			return interact(second_word)
		"inventory":
			return view_inventory()
		"clear":
			return clear_commands()
		_:
			return "Sorry, you can't do that"


func go(second_word) -> String:
	if second_word == "" && GlobalPlayerData.has_limbs:
		return "Go where?"
	elif second_word == "" && !GlobalPlayerData.has_limbs:
		return "First, you must find some LIMBS to move around."
	
	if current_location.exits.keys().has(second_word) && GlobalPlayerData.has_limbs:
		var new_location: Location = current_location.exits[second_word]
		change_location(new_location)
		return ""
	elif current_location.exits.keys().has(second_word) && !GlobalPlayerData.has_limbs:
		return "You need LIMBS before you can move."
	else:
		return "You can't get there from here."


func look(second_word) -> String:
	if second_word == "":
		return "Look at what?"
	elif second_word == "pockets":
		return view_inventory()
	elif second_word == "bench":
		return $"../LocationManager/Bench".location_description
	elif second_word == "door":
		return $"../LocationManager/WorkshopDoor".location_description
	elif second_word == "self":
		if GlobalPlayerData.parts_installed && !GlobalPlayerData.limbs_attached:
			return "With PARTS installed, you already feel better. If only you had LIMBS."
		elif !GlobalPlayerData.parts_installed && GlobalPlayerData.limbs_attached:
			return "You have LIMBS now, but without installed PARTS, you won't make it very far."
		elif GlobalPlayerData.parts_installed && GlobalPlayerData.limbs_attached:
			return "You are a fully assembled Robot! Now it's time to GO and explore the world!"
		else:
			return "You look at yourself, a partially built robot body laying on the slab table. Thankfully, your wi-fi module works, so you can connect to nearby electronics."
	elif second_word == "locker":
		if current_location == $"../LocationManager/Locker":
			return "The LOCKER has more spare PARTS and TOOLS in it. You can TAKE these, they should be helpful on your adventure."
		return $"../LocationManager/Locker".location_description + "There's probably more useful things in here that will require closer inspection."
	elif second_word == "machinery":
		if !GlobalPlayerData.machinery_activated:
			return $"../LocationManager/Machinery".location_description
		elif GlobalPlayerData.machinery_activated:
			return "The MACHINERY hums with life, the TERMINAL can be used to command the MANIPULATOR to GRAB, and the ACTIVATE the CRANE."
	elif second_word == "table":
		return $"../LocationManager/StartingLocation".location_description
	elif second_word == "tools":
		return "Some tools that would be helpful in building and repairing robots like you."
	elif second_word == "parts":
		return "These parts seem like they would fit nicely in your robot body."
	elif second_word == "terminal":
		return "This TERMINAL likely controls the MACHINERY nearby."
	elif second_word == "limbs":
		return "LIMBS! You need to find a way to get these so you can move around!"
	elif second_word == "manipulator":
		return "This MANIPULATOR can use TOOLS to attach LIMBS to a robot body like yours."
	elif second_word == "crane":
		return "This CRANE can move LIMBS or PARTS around the Workshop, it might be helpful."
	return "You look at " + second_word


func interact(second_word):
	if second_word == "":
		return "interact with what?"
	elif second_word == "terminal":
		GlobalPlayerData.terminal_activated = true
		return " You activate the TERMINAL. You can now press [CTRL] to use the TERMINAL and enter a NAME or ACTIVATE the MACHINERY."
	return "You can't do that."


func take():
	return "soon"

func view_inventory():
	return "You check, and find your pockets empty."


func help():
	return "Valid commands are: GO, LOOK, INTERACT, TAKE, HELP, CLEAR. Objects in BOLD are interactible. INVENTORY to open inventory, or LOOK POCKETS. LOOK SELF to examine yourself. [Alt] to open character panel."


func clear_commands():
	clear_responses_generated.emit()
	change_location(current_location)
	return ""


func change_location(new_location):
	print("received command")
	current_location = new_location
	var exits = PackedStringArray(new_location.exits.keys())
	var strings = "\n".join(PackedStringArray([
		"Location: " + new_location.location_name,
		new_location.location_description,
		"Available locations: " + ", ".join(exits)
	]))
	response_generated.emit(strings)
	print("change location test passed")
