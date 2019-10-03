extends KinematicBody2D

export(int) var SPEED
export(float) var MAXHP

signal shoot(damage, speed, spread, projectile_count)
signal health_update(new_health)
signal playerdeath
signal pickupitem(item)
signal weapon_update(weapon_id,ammo_left)
signal reload
signal reload_finished
signal heal(timer)

onready var velocity = Vector2()
onready var direction = "front"
onready var fireready = true
onready var type = "player"
onready var health = MAXHP
onready var godmode  = false
onready var interactables = []
onready var weapons = [null,null] #no way to encapsulate an array, _set_weapon should be used to set weapons[] values
onready var selected_weapon = 0
onready var reloading = false
onready var healing = false
var heal_amount
var fire_mode
var armour setget _set_armour #encapsulates armour, setting armour will call the _set_armour method

#runs when player enters scene, sets camera to current
func _ready():
	$FireRateTimer.set_wait_time(0.1)
	$Camera2D.make_current()
	$Weapon.flip_h = true

#emits health_update signal
func _respawn_init():
	emit_signal("health_update",health)
		
#runs every process cycle, detects player input and calls the appropriate method
func _process(delta):
	#input
	velocity = Vector2()
	#movement
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
		direction = "front"
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
		direction = "back"
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
		direction = "left"
		$AnimatedSprite.flip_h = true
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
		direction = "left"
		$AnimatedSprite.flip_h = false
	if velocity.length() > 0:
		velocity = velocity.normalized() * SPEED
		$AnimatedSprite.animation = direction + "_walking"
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.animation = direction
		$AnimatedSprite.stop()
	move_and_slide(velocity)
	#weapons
	if fire_mode:
		if Input.is_action_pressed("mouse_1"):
			_shoot()
	elif Input.is_action_just_pressed("mouse_1"):
			_shoot()
	if Input.is_action_just_pressed("ui_interact"):
		_interact()
	if Input.is_action_just_pressed("ui_switch_weapon"):
		_switch_weapon()
	
	#healing
	if !healing && !reloading:
		if Input.is_action_pressed("heal_bandage"):
			if Global.main_scene.get_node("Inventory")._find_and_consume_item(18):
				_heal(18)
		if Input.is_action_pressed("heal_syringe"):
			if Global.main_scene.get_node("Inventory")._find_and_consume_item(19):
				_heal(19)
		if Input.is_action_pressed("heal_medkit"):
			if Global.main_scene.get_node("Inventory")._find_and_consume_item(20):
				_heal(20)
	
#attempts to shoot the player's currently selected weapon if not reloading or healing
func _shoot():
	if fireready == true && weapons[selected_weapon] != null && !reloading && !healing:
		if weapons[selected_weapon]._fire():
			_show_weapon()
			emit_signal("shoot", weapons[selected_weapon].base_damage,weapons[selected_weapon].projectile_speed,weapons[selected_weapon].spread,weapons[selected_weapon].projectile_count)
			emit_signal("weapon_update", weapons[selected_weapon].id,weapons[selected_weapon].ammo_left)
			$FireRateTimer.start()
			fireready = false
		else:
			_reload()

#will switch weapon if the non-active weapon slot is occupied
func _switch_weapon():
	if !reloading:
		if selected_weapon == 0:
			if weapons[1] != null:
				selected_weapon = 1
				emit_signal("weapon_update", weapons[1].id,weapons[1].ammo_left)
				_update_weapon_sprite()
				_update_weapon_properties()
		else:
			if weapons[0] != null:
				selected_weapon = 0
				emit_signal("weapon_update", weapons[0].id,weapons[0].ammo_left)
				_update_weapon_sprite()
				_update_weapon_properties()

#starts the healing process:
#sets healing to true, the active healing item is set
#starts healing timer and shows healing text on screen
func _heal(var id):
	healing = true
	$HealingTimer.wait_time = ItemData.items[id].heal_time
	$HealingTimer.start()
	emit_signal("heal", $HealingTimer)
	heal_amount = ItemData.items[id].hp

#damages the player for value of hit taking into account armour protection
#and kills the player if health falls below 0
func damage(var hit):
	if !godmode:
		health -= hit * (1 - _get_armour_protection()/100)
		if health <= 0:
			emit_signal("playerdeath")
			hide()
			queue_free()
		emit_signal("health_update",health)

#scans through objects within interactables array, finds closest to player and runs the interact method on it
func _interact():
	var closest_object
	var closest_object_dist = 10000
	if interactables.size() == 0:
		return
	for object in interactables:
		var offset = object.global_position-global_position
		var dist = cartesian2polar(offset.x,offset.y).x
		if dist < closest_object_dist:
			closest_object = object
			closest_object_dist = dist
	if closest_object.is_in_group("lootchest"):
		closest_object._interact()
	else:
		closest_object.get_parent()._interact()

#reloads the currently selected weapon and shows reloading GUI
func _reload():
	weapons[selected_weapon]._reload()
	reloading = true
	$ReloadTimer.start()
	emit_signal("reload")

#shows weapon and rotates it the direction of the mouse
func _show_weapon():
	var dir = (get_global_mouse_position() - Global.main_scene._get_Player_position())
	$Weapon.rotation = cartesian2polar(dir.x,dir.y).y
	if $Weapon.rotation_degrees >= -90 && $Weapon.rotation_degrees <= 90:
		$Weapon.flip_v = false
	else:
		$Weapon.flip_v = true
	if !$Weapon.visible:
		$Weapon.show()
	$WeaponVisibleTimer.start()

#updates weapon sprite to match that of the selected weapon
func _update_weapon_sprite():
	$Weapon.set_region_rect(ItemUtils._get_item_sprite_rect(weapons[selected_weapon].id))

#sets a weapon of weapon id in specified slot 0 or 1 (-1 = no weapon)
func _set_weapon(var id, var slot): 
	if id != -1:
		weapons[slot] = ItemData.items[id]
		if selected_weapon == slot:
			emit_signal("weapon_update", weapons[slot].id,weapons[slot].ammo_left)
			_update_weapon_sprite()
		elif (selected_weapon == 0 && weapons[0] ==null) || (selected_weapon == 1 && weapons[1] == null):
			_switch_weapon()
		_update_weapon_properties()
	else:
		weapons[slot] = null
		if selected_weapon==slot:
			emit_signal("weapon_update", -1, -1)
			_switch_weapon()

#same as above method except for players armour (-1 = no armour)
func _set_armour(var id):
	if id != -1:
		armour = ItemData.items[id]
	else:
		armour = null
		
#updates fire rate and fire mode variables
func _update_weapon_properties():
	$FireRateTimer.set_wait_time(60/weapons[selected_weapon].fire_rate)
	fire_mode = weapons[selected_weapon].fire_mode

#sets position to pos and makes player visible
func _start(pos):
	position = pos
	show()

#returns equipped armour protection and returns 0 if no armour equipped
func _get_armour_protection():
	if armour != null:
		return armour.protection
	return 0

#runs when FireRateTimer is finished and sets fireready to true
func _on_FireRateTimer_timeout():
	fireready = true

#sets godmode to mode (for debugging)
func _toggle_godmode(var mode):
	godmode = mode

#clears interactables array
func _clear_interactables():
	interactables = []

#runs when ItemRadius is entered and emits signal pickupitem if area is a world item
func _on_ItemRadius_area_entered(area):
	if area.is_in_group("worlditem"):
		emit_signal("pickupitem",area)

#runs when InteractRadius is entered and adds area to interactables if it is interactable
func _on_InteractRadius_area_entered(area):
	if area.is_in_group("interactable"):
		interactables.append(area)
		
#runs when InteractRadius is exited and removes area from interactables if it is interactable
func _on_InteractRadius_area_exited(area):
	if area.is_in_group("interactable"):
		var index = interactables.find(area)
		if index != -1:
			interactables.remove(index)

#hides weapon when WeaponVisibleTimer finishes
func _on_WeaponVisibleTimer_timeout():
	$Weapon.hide()

#sets reloading to falsem emits signals weapon_update and reload_finished
func _on_ReloadTimer_timeout():
	reloading = false
	emit_signal("weapon_update", weapons[selected_weapon].id,weapons[selected_weapon].ammo_left)
	emit_signal("reload_finished")

#when HealingTimer runs out heals for heal_amount
func _on_HealingTimer_timeout():
	health += heal_amount
	if health > 100:
		health = 100
	healing = false
	emit_signal("health_update",health)
