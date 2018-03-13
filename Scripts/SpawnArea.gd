extends Area2D
var is_in_range = true
export (float) var rate
export (int) var limit
export(int) var type
signal spawn(pos, extents, type)

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	_on_SpawnRateTimer_timeout()
	$SpawnRateTimer.start()
	type = 1

func _process(delta):
	pass


func _on_SpawnArea_body_entered( body ):
	if body.is_in_group("radius"):
		is_in_range = true


func _on_SpawnRateTimer_timeout():
	if is_in_range:
		emit_signal("spawn", position , Vector2($CollisionShape2D.get_shape().extents.x*scale.x,$CollisionShape2D.get_shape().extents.y*scale.y) , type)
		$SpawnRateTimer.start()
		

func _on_SpawnArea_body_exited( body ):
	if body.is_in_group("radius"):
		is_in_range = false