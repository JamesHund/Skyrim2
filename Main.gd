extends Node2D

onready var projectile = preload("res://Scenes//Projectile.tscn")

var player_is_alive

func _ready():
	$Player.start(Vector2(64, 64))
	player_is_alive = true
	
func _process(delta):
	if player_is_alive:
		$Player/Camera2D/HP.text = str($Player.health)

func _on_Player_shoot():
	var new_projectile = projectile.instance()
	add_child(new_projectile)
	new_projectile._initialize(get_global_mouse_position()-$Player.position, $Player)

func _on_Enemy_shoot():
	if player_is_alive:
		var new_projectile = projectile.instance()
		add_child(new_projectile)
		new_projectile._initialize($Player.position-$Enemy.position, $Enemy)


func _on_Player_playerdeath():
	player_is_alive = false