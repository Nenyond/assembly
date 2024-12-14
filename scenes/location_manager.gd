extends Node


func _ready() -> void:
	$StartingLocation.connect_exits("bench", $Bench)
	$StartingLocation.connect_exits("locker", $Locker)
	$StartingLocation.connect_exits("machinery", $Machinery)
	$StartingLocation.connect_exits("door", $WorkshopDoor)

	$WorkshopDoor.connect_exits("outside", $Outside)

	var parts = Item.new()
	var supplies = Item.new()
	var tools = Item.new()
	parts.initialize("PARTS", Global.ItemTypes.PARTS)
	supplies.initialize("SUPPLIES", Global.ItemTypes.SUPPLIES)
	tools.initialize("TOOLS", Global.ItemTypes.TOOLS)
	
	$Locker.add_items(parts)
	$Locker.add_items(supplies)
	$Locker.add_items(tools)
	
