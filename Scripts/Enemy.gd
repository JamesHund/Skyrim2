extends KinematicBody2D
signal shoot(instance) #in process of changing enemy shoot method to work with all enemies (eliminate $Enemy in main basically)
var type = "enemy"
export(float)var MAXHP
var health
var resistance = 100
var fireready
var movement

func start(pos):
	position = pos
	show()

func _ready():
	$FireRateTimer.set_wait_time(0.3)
	health = 3
	fireready = true

func _process(delta):
	var velocity = Vector2()
	velocity.y = 1
	velocity.x = 0
	move_and_collide(velocity*delta*300)
	if fireready:
		emit_signal("shoot", self)
		$FireRateTimer.start()
		fireready = false

func damage(var hit):
	health -= hit * resistance/100
	if health <= 0:
		hide()
		queue_free()
		

func _on_FireRateTimer_timeout():
	fireready = true