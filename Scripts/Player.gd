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
onready var resistance = 100
onready var godmode  = false
var weapon
var armor

func _ready():
	$FireRateTimer.set_wait_time(0.1)
	$Camera2D.make_current()
	#fix firerate

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
		if fireready == true:
			emit_signal("shoot")
			$FireRateTimer.start()
			fireready = false
	
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
		health -= hit * resistance/100
		if health <= 0:
			emit_signal("playerdeath")
			hide()
			queue_free()
		emit_signal("health_update",health)
	
func start(pos):
	position = pos
	show()
	
func _on_FireRateTimer_timeout():
	fireready = true
	
func _toggle_godmode(var mode):
	godmode = mode

func _on_ItemRadius_body_entered(body):
	if body.is_in_group("worlditem"):
		emit_signal("pickupitem",body)
