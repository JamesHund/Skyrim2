extends MarginContainer

var id
signal set_current(id)

func _initialize(var _id):
	id = _id
	_set_sprite(id)
	_set_item_name(id)
	
func _set_sprite(var _id):
	$HBoxContainer/IconContainer/Sprite.set_region_rect(ItemUtils._get_item_sprite_rect(_id))
	
func _set_item_name(var _id):
	$HBoxContainer/ItemName.set_text(ItemData.items[_id].item_name)
	
func _update_button_region():
	pass


func _on_TextureButton_pressed():
	emit_signal("set_current", id)
