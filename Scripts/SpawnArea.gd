extends Area2D
var is_in_range = false
export (float) var rate
export (int) var limit
export(int) var type
signal spawn(pos, extents, type)
onready var enemy_count = 0

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	_on_SpawnRateTimer_timeout()
	$SpawnRateTimer.set_wait_time(1/rate)
	type = 9


func _on_SpawnRateTimer_timeout():
	if enemy_count <= limit:
		print("spawn enemy")
		emit_signal("spawn", position , Vector2($CollisionShape2D.get_shape().extents.x*scale.x,$CollisionShape2D.get_shape().extents.y*scale.y) , type)
		enemy_count += 1
	else:
		enemy_count = 0
		$CoolDownTimer.start()
		$SpawnRateTimer.stop()
		set_monitoring(false)
		
		

func _on_SpawnArea_area_entered(area):
	if area.is_in_group("spawnradius"):
		is_in_range = true
		$SpawnRateTimer.start()


func _on_SpawnArea_area_exited(area):
	if area.is_in_group("spawnradius"):
		is_in_range = false
		$SpawnRateTimer.stop()


func _on_CoolDownTimer_timeout():
	set_monitoring(true)
