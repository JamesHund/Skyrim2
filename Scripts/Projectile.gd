extends Area2D

var direction
var source
var group
export (int) var SPEED
var speedtest

func _ready():
	pass
	
func _initialize(dir, src):
	position = src.position
	source = src
	if src.is_in_group("players"):
		group = "players"
	else:
		group = "enemies"
	direction = dir
	$DecayTimer.start()
	speedtest = 0
	

func _process(delta):
	position += direction.normalized()*SPEED*delta
	speedtest+= delta
	if speedtest >= 1:
		print(SPEED*delta)
		speedtest -= 1
		


func _on_DecayTimer_timeout():
	hide()
	queue_free()


func _on_Projectile_body_entered( body ):
	if body.is_in_group("characters"):
		if !body.is_in_group(group):
			body.damage(5)
			hide()
			queue_free()
	else:
		hide()
		queue_free()
