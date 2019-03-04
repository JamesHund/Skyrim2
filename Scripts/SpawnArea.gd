extends Area2D
var is_in_range = false
var spawn_ready
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
	type = 9

func _process(delta):
	if is_in_range && spawn_ready:
		emit_signal("spawn", position , Vector2($CollisionShape2D.get_shape().extents.x*scale.x,$CollisionShape2D.get_shape().extents.y*scale.y) , type)
		spawn_ready = false
		$SpawnRateTimer.start()

func _on_SpawnRateTimer_timeout():
	spawn_ready = true
		

func _on_SpawnArea_area_entered(area):
	if area.is_in_group("radius"):
		is_in_range = true


func _on_SpawnArea_area_exited(area):
	if area.is_in_group("radius"):
		is_in_range = false
