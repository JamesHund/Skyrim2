extends RemoteTransform2D

#a scene that acts as a visual representation of an item in the inventory
#it doesn't store any item data
#it displays the sprite for the item and can be dragged and released

signal released(pos,grid)
var item_to_mouse #offset from item to mouse at the moment bject is dragged
onready var origin_pos = position
onready var grid_pos = Vector2(int(get_parent().get_name().right(1)),int(get_parent().get_name().left(1))) #position in inventory

func _ready():
	$Sprite.hide()
	$TextureButton.set_mouse_filter(2)
	$StackSize.set_text("")

func _set_sprite(var id, var stacksize):#takes in an item id and reassigns sprite
	if id != -1:
		$TextureButton.set_mouse_filter(0)
		$Sprite.set_region_rect(ItemUtils._get_item_sprite_rect(id))
		$Sprite.show()
	else:
		$Sprite.hide()
		$TextureButton.set_mouse_filter(2)
	if stacksize > 1:
		$StackSize.set_text(str(stacksize))
	else:
		$StackSize.set_text("")

func _begin_mouse_follow():
	set_z_index(5)
	item_to_mouse = get_local_mouse_position()
	$MouseFollowTimer.start()
	
func _end_mouse_follow():
	set_z_index(4)
	$MouseFollowTimer.stop()
	emit_signal("released",Vector2(global_position.x + 40, global_position.y + 40),grid_pos)
	position = origin_pos
	

func _on_MouseFollowTimer_timeout():
	var offset = Vector2(get_local_mouse_position().x - item_to_mouse.x , get_local_mouse_position().y - item_to_mouse.y)
	translate(offset)


func _on_TextureButton_button_down():
	_begin_mouse_follow()


func _on_TextureButton_button_up():
	_end_mouse_follow()