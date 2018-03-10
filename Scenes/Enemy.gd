extends KinematicBody2D
signal shoot
var type = "enemy"
export(float)var MAXHP
var health
var resistance = 100

func _ready():
	$FireRateTimer.set_wait_time(0,3)
	health = 3

func _process(delta):
	var velocity = Vector2()
	velocity.y = 1
	velocity.x = 0
	move_and_collide(velocity*delta*300)
	emit_signal("shoot")

func damage(var hit):
	health -= hit * resistance/100
	if health <= 0:
		hide()
		queue_free()
		