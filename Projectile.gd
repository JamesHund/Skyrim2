extends Area2D

var direction
var source
export (int) var SPEED

func _ready():
	pass
	
func _initialize(dir, src):
	position = src.position
	source = src
	direction = dir
	$DecayTimer.start()
	print("woohoo")
	

func _process(delta):
	position += direction.normalized()*SPEED*delta


func _on_DecayTimer_timeout():
	hide()
	queue_free()


func _on_Projectile_body_entered( body ):
	if body.get_instance_id() != source.get_instance_id():
		if body.is_in_group("walls"):
			body.queue_free()
			print(body.get_instance_id())
			#make a kill method in enemies
		else:
			hide()
			queue_free()
