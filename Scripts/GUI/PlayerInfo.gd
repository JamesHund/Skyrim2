extends MarginContainer

var ammo_capacity

func _ready():
	$VBoxContainer/BottomBar/WeaponContainer.hide()
	
func _set_health(var value):
	$VBoxContainer/BottomBar/HealthContainer/HBoxContainer/CenterContainer/TextureProgress.set_value(value)
	$VBoxContainer/BottomBar/HealthContainer/HBoxContainer/CenterContainer2/Health.set_text(str(value))

func _set_weapon(var id, var ammo_left):
	if ItemData.items[id].type == 1:
		$Sprite.set_region_rect(ItemUtils._get_item_sprite_rect(id))
		ammo_capacity = ItemData.items[id].base_capacity
		_update_ammo(ammo_left)
		$VBoxContainer/BottomBar/WeaponContainer.show()
	else:
		printerr("Item is not a weapon")
		
func _update_ammo(var ammo_left):
	$VBoxContainer/BottomBar/WeaponContainer/RichTextLabel.set_bbcode_text(str(ammo_left) + "/" + str(ammo_capacity))
	
func _hide_ammo():
	$VBoxContainer/BottomBar/WeaponContainer.hide()