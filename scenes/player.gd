extends Node


var inventory = []

func take_item(item: Item):
	inventory.append(item)
	
func drop_item(item: Item):
	inventory.erase(item)

func get_inventory() -> String:
	if inventory.size() == 0:
		return "Your storage is empty."
	
	var item_string = ""
	for item in inventory:
		item_string += item.item_name + " "
	return "Items in storage: " + item_string
