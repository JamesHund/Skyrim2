extends Node2D

onready var projectile = preload("res://Scenes//Projectile.tscn")

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	$Player.start(Vector2(64, 64))
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_Player_shoot():
	var new_projectile = projectile.instance()
	add_child(new_projectile)
	new_projectile._initialize(get_global_mouse_position()-$Player.position, $Player)
