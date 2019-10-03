extends Area2D

#Item that is placed in the world

var item
export (bool) var hand_placed = false
export (int) var id
export (int) var stacksize

#performs required initialization of variables if WorldItem is hand placed
func _ready():
	if hand_placed:
		monitorable=true
		item = ItemUtils._create_item(id,stacksize)
		if item.type != 4: #checks to see if it is quest item
			$DecayTimer.start()
		else:
			if(QuestHandler._item_is_collected(item.quest_id)):
				queue_free()
		$Sprite.set_region_rect(ItemUtils._get_item_sprite_rect(id))
		show()

#initilizes variables and starts DecayTimer and PickupTimer
func _initialize(var _id, var _stacksize, var pos, var pickupcooldown):
	id = _id
	stacksize = _stacksize
	item = ItemUtils._create_item(id,stacksize)
	if item.type != 4:
		$DecayTimer.start()
	$Sprite.set_region_rect(ItemUtils._get_item_sprite_rect(id))
	position = pos
	show()
	$PickupTimer.set_wait_time(pickupcooldown)
	$PickupTimer.start()
	
#deletes WorldItem
func _on_DecayTimer_timeout():
	hide()
	queue_free()

#makes the item able to be picked up
func _on_PickupTimer_timeout():
	monitorable=true
