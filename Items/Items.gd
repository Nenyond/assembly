extends Resource
class_name Item

@export var item_name: String = ""
@export var item_description: Global.ItemTypes 

func initialize(item_name: String, item_description: Global.ItemTypes):
	self.item_name = item_name
	self.item_description = item_description
