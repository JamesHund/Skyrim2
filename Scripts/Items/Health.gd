extends Item

class_name Health, "res://Scripts/Items/Health.gd"

var hp
var heal_time

#initializes variables
func _init(var _id, var _item_name, var _stack_size, var _max_stack_size,var _hp, var _heal_time ).(_id, _item_name, 3, _stack_size, _max_stack_size):
	hp = _hp
	heal_time = _heal_time
	

	
