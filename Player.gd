extends KinematicBody2D

export(int) var SPEED
export(float) var FIRERATE
var velocity = Vector2()
var direction = "front"
signal shoot
var fireready = true

func _ready():
	$FireRateTimer.set_wait_time(0.1)
	#fix firerate
	pass

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
	
	


	
func start(pos):
	position = pos
	show()
	


func _on_FireRateTimer_timeout():
	fireready = true