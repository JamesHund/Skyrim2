extends KinematicBody2D
signal shoot(instance)
var type = "enemy"
export(float)var MAXHP
var health
var resistance = 100
var fireready
var movement
var processintervals
var velocity

func start(pos):
	position = pos
	show()

func _ready():
	$FireRateTimer.set_wait_time(0.3)
	health = 10
	fireready = true
	processintervals = 0.0
	velocity = Vector2(randi()%3-1, randi()%3-1)

func _process(delta):
	processintervals += delta
	if(processintervals >= 4):
		velocity = Vector2(randi()%3+1, randi()%3+1)
		processintervals -= 4
	move_and_collide(velocity.normalized()*delta*100)
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