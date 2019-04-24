extends Area2D

var item

func _ready():
	pass
	
func _initialize(var id, var stacksize, var pos):
	item = ItemUtils._create_item(id,stacksize)
	$Sprite.set_region_rect(ItemUtils._get_item_sprite_rect(id))
	position = pos
	show()
	
func _on_DecayTimer_timeout():
	hide()
	queue_free()
