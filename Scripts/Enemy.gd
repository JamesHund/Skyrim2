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
var tilemap_ref

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
		#print(tilemap_ref.call("world_to_map",position))
	move_and_collide(velocity.normalized()*delta*100)


func damage(var hit):
	health -= hit * resistance/100
	if health <= 0:
		hide()
		queue_free()
		
func shoot():
	emit_signal("shoot", self)
	
func _get_path():
	pass
	
func _on_FireRateTimer_timeout():
	shoot()
	

func _on_RecalculateNode_timeout():
	call_deferred("_get_path")
	
func _tilemap_call(var method, var param1 = null, var param2 = null):
	#create a reference to tilemap
	#call method using tilemap_reference.call()
	
	pass
