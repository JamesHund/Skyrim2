extends Node2D

signal dropitem(items)

onready var open = false

func _ready():
	pass

func _interact():
	if !open:
		open = true
		$Sprite.set_frame(1)
		
func _generate_items():
	for entry in ItemData.loot_table:
		randomize()
		#if rand_range()
	