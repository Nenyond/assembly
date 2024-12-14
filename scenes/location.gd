extends PanelContainer

class_name Location

@export var location_name: String
@export var location_description: String

var exits: Dictionary = {}
var items: Array = []


func add_items(item: Item):
	items.append(item)
	

func remove_items(item: Item):
	items.erase(item)

func get_full_desc_string() -> String:
	
	var strings = "\n".join(PackedStringArray([
		get_location_name(),
		get_location_desc(),
		get_items(),
		get_exits_desc()
	]))
	return strings


func get_items() -> String:
	if items.size() == 0:
		return "There are no items to TAKE."
	
	var item_string = ""
	for item in items:
		item_string += item.item_name + " "
	return "Items: " + item_string


func get_exits_desc():
	var exits = PackedStringArray(exits.keys())
	return "Available locations: " + ", ".join(exits)


func get_location_name() -> String:
	return "Location: " + location_name


func get_location_desc() -> String:
	return location_description


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
		"outside":
			exits[direction] = location 
			location.exits['door'] = self
		_:
			return "Please choose another location"
