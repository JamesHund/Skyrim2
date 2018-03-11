extends Node
signal next_level
# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	
	pass
	
func _on_area2d_area_entered():
	emit_signal("next_level")
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
