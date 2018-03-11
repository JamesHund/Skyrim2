extends Area2D
var is_in_range = false
export (float) var rate
export (int) var limit
signal spawn

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	$SpawnRateTimer.set_wait_time(0.1)

func _process(delta):
	pass


func _on_SpawnArea_body_entered( body ):
	if body.is_in_group("radius"):
		is_in_range = true


func _on_SpawnRateTimer_timeout():
	if is_in_range:
		emit_signal("spawn")
		$SpawnRateTimer.start()
		

func _on_SpawnArea_body_exited( body ):
	if body.is_in_group("radius"):
		is_in_range = false