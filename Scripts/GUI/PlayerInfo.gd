extends MarginContainer

var ammo_capacity

#called on entering SceneTree, hides WeaponContainer
func _ready():
	$VBoxContainer/BottomBar/WeaponContainer.hide()

#sets health displayed to value, rounding it off
func _set_health(var value):
	if value < 0:
		value = 0
	else:
		value = round(value)
	$VBoxContainer/BottomBar/HealthContainer/HBoxContainer/CenterContainer/TextureProgress.set_value(value)
	$VBoxContainer/BottomBar/HealthContainer/HBoxContainer/CenterContainer2/Health.set_text(str(value))

#displays weapon determined by id and shows the ammo_left
func _set_weapon(var id, var ammo_left):
	if id == -1:
		_hide_ammo()
		return
	if ItemData.items[id].type == 1:
		$VBoxContainer/BottomBar/WeaponContainer/Sprite.set_region_rect(ItemUtils._get_item_sprite_rect(id))
		ammo_capacity = ItemData.items[id].base_capacity
		_update_ammo(ammo_left)
		$VBoxContainer/BottomBar/WeaponContainer.show()
	else:
		printerr("Item is not a weapon")
		
#updates the ammo display to reflect new ammunition left
func _update_ammo(var ammo_left):
	$VBoxContainer/BottomBar/WeaponContainer/RichTextLabel.bbcode_text = "[right]" + str(ammo_left) + "/" + str(ammo_capacity)

#hides WeaponContainer
func _hide_ammo():
	$VBoxContainer/BottomBar/WeaponContainer.hide()