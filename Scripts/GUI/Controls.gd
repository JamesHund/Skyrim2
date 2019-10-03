extends MarginContainer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Control_visibility_changed():
	if is_visible_in_tree():
		get_tree().set_pause(true)
	else:
		get_tree().set_pause(false)
