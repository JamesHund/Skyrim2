extends MarginContainer

var id
signal set_current(id)

#sets merchant item to display item of  _id
func _initialize(var _id):
	id = _id
	_set_sprite(id)
	_set_item_name(id)

#sets sprite to item of _id
func _set_sprite(var _id):
	$HBoxContainer/IconContainer/Sprite.set_region_rect(ItemUtils._get_item_sprite_rect(_id))

#sets name to item_name of _id
func _set_item_name(var _id):
	$HBoxContainer/ItemName.set_text(ItemData.items[_id].item_name)

#emits signal "set_current" with id as a parameter
func _on_TextureButton_pressed():
	emit_signal("set_current", id)
