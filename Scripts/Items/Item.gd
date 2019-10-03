extends Node2D

class_name Item, "res://Scripts/Items/Item.gd"

var id
var item_name
var type
var stack_size
var max_stack_size

#initializes fields
func _init(var _id, var _item_name, var _type, var _stack_size, var _max_stack_size):
	id = int(_id)
	item_name = _item_name
	type = _type
	max_stack_size = _max_stack_size
	if _stack_size > _max_stack_size:
		stack_size = max_stack_size
	else:
		stack_size = _stack_size
	
