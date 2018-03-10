extends KinematicBody2D

export(int) var SPEED
export(float) var FIRERATE
export(float) var MAXHP

signal shoot
signal playerdeath

var velocity = Vector2()
var direction = "front"
var fireready = true
var type = "player"
var health
var resistance

func _ready():
	health = MAXHP
	resistance = 100
	$FireRateTimer.set_wait_time(0.1)
	#fix firerate

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
		
	#change in position
	move_and_collide(velocity*delta)
	
func damage(var hit):
	health -= hit * resistance/100
	if health <= 0:
		emit_signal("playerdeath")
		hide()
		queue_free()
	

func start(pos):
	position = pos
	show()
	
func _on_FireRateTimer_timeout():
	fireready = true