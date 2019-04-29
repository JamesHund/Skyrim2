extends Area2D

var item

func _ready():
	pass
	
func _initialize(var id, var stacksize, var pos, var pickupcooldown):
	item = ItemUtils._create_item(id,stacksize)
	if item.type != 4:
		$DecayTimer.start()
	$Sprite.set_region_rect(ItemUtils._get_item_sprite_rect(id))
	position = pos
	show()
	$PickupTimer.set_wait_time(pickupcooldown)
	$PickupTimer.start()
	
	
func _on_DecayTimer_timeout():
	hide()
	queue_free()
	



func _on_PickupTimer_timeout():
	monitorable=true
