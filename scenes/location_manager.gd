extends Node


func _ready() -> void:
	$StartingLocation.connect_exits("bench", $Bench)
	$StartingLocation.connect_exits("locker", $Locker)
	$StartingLocation.connect_exits("machinery", $Machinery)
	$StartingLocation.connect_exits("door", $WorkshopDoor)
