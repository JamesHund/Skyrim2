extends KinematicBody2D

export(int) var SPEED
export(float) var MAXHP

signal shoot
signal health_update(new_health)
signal playerdeath
signal pickupitem(item)

onready var velocity = Vector2()
onready var direction = "front"
onready var fireready = true
onready var type = "player"
onready var health = MAXHP
onready var godmode  = false
onready var interactables = []
onready var weapons = [null,null]
onready var selected_weapon = 0
var armour


func _ready():
	$FireRateTimer.set_wait_time(0.1)
	$Camera2D.make_current()

func _respawn_init():
	emit_signal("health_update",health)
		

func _process(delta):
	#input
	velocity = Vector2()
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
	if Input.is_action_pressed("mouse_1"):
		if fireready == true && selected_weapon != null:
			emit_signal("shoot")
			$FireRateTimer.start()
			fireready = false
	if Input.is_action_pressed("ui_interact"):
		_interact()
	if Input.is_action_pressed("ui_switch_weapon"):
		selected_weapon = weapons[0]
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * SPEED
		$AnimatedSprite.animation = direction + "_walking"
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.animation = direction
		$AnimatedSprite.stop()
	move_and_slide(velocity)

	
func damage(var hit):
	if !godmode:
		health -= hit * (1 - _get_armour_protection()/100)
		if health <= 0:
			emit_signal("playerdeath")
			hide()
			queue_free()
		emit_signal("health_update",health)
		
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
	
func _set_weapon(var id, var slot): #sets a weapon of weapon id in specified slot 0 or 1 (-1 = no weapon)
	if id != -1:
		weapons[slot] = ItemData.items[id]
	else:
		weapons[slot] = null
		
func _set_armour(var id): #same as above method except for players armour (-1 = no armour)
	if id != -1:
		armour = ItemData.items[id]
	else:
		armour = null
func start(pos):
	position = pos
	show()
	
func _get_armour_protection():
	if armour != null:
		return armour.protection
	return 0
	
func _on_FireRateTimer_timeout():
	fireready = true
	
func _toggle_godmode(var mode):
	godmode = mode

func _clear_interactables():
	interactables = []

func _on_ItemRadius_area_entered(area):
	if area.is_in_group("worlditem"):
		emit_signal("pickupitem",area)

func _on_InteractRadius_area_entered(area):
	if area.is_in_group("interactable"):
		interactables.append(area)
		
func _on_InteractRadius_area_exited(area):
	if area.is_in_group("interactable"):
		var index = interactables.find(area)
		if index != -1:
			interactables.remove(index)
