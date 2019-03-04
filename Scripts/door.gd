extends Node2D
signal teleport(level, pos)

export(String) var level
export(Vector2) var pos

var enterable = true

func _ready():
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _on_Area2D_body_entered( body ):
	if enterable && (body.is_in_group("players")):
		enterable = false
		emit_signal("teleport", level, pos)
		print("teleporting")
		$EnteredTimer.start()


func _on_EnteredTimer_timeout():
	enterable = true
