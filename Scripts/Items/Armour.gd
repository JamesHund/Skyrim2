extends Item

class_name Armour, "res://Scripts/Items/Armour.gd"

var protection

#initializes variables
func _init(var _id, var _item_name, var _protection).(_id, _item_name,0, 1, 1):
	protection = _protection