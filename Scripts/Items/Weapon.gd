extends Item

class_name Weapon, "res://Scripts/Items/Weapon.gd"

var base_damage
var fire_mode
var fire_rate
var projectile_count
var spread
var projectile_speed
var base_capacity
var ammo_left

func _init(var _id, var _item_name, var _base_damage,  var _fire_mode, var _fire_rate, var _projectile_count, var _spread, var _projectile_speed, var _base_capacity).(_id,_item_name,1, 1, 1):
	base_damage = _base_damage
	fire_mode = _fire_mode
	fire_rate = _fire_rate
	projectile_count = _projectile_count
	spread = _spread
	projectile_speed = _projectile_speed
	base_capacity = _base_capacity
	ammo_left = base_capacity
	
func yeet():
	return str(base_damage) + item_name
	
