extends PanelContainer

class_name Location

@export var location_name: String
@export var location_description: String

var exits: Dictionary = {}


func connect_exits(direction: String, location):
	match direction:
		"bench":
			exits[direction] = location
			location.exits["table"] = self
		"locker":
			exits[direction] = location
			location.exits['table'] = self
		"machinery":
			exits[direction] = location
			location.exits['table'] = self
		"table":
			exits[direction] = location
			location.exits['table'] = self
		"door":
			exits[direction] = location
			location.exits['table'] = self
		_:
			return "Please choose another location"
