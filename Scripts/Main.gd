extends Node2D

onready var projectile = preload("res://Scenes//Projectile.tscn")
onready var secondworld = preload("res://Scenes//Levels//SecondWorld.tscn")
onready var level = preload("res://Scenes//Level.tscn")
onready var enemy = preload("res://Scenes//Enemy.tscn")
onready var player = preload("res://Scenes//Player.tscn")

var player_is_alive
var enemy_list

func _ready():
	$Player.start(Vector2(538, 320))
	player_is_alive = true
	$Level/TestWorld/Door.connect("teleport",self,"_on_door_teleport")
	
func _process(delta):
#	if player_is_alive:
		#$Player/Camera2D/HP.text = str($Player.health)
		pass

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
	$RespawnTimer.start()

func _on_SpawnArea_spawn():
	var new_enemy = enemy.instance()
	add_child(new_enemy)
	new_enemy._initialize(Vector2(0,0))
	
func respawn():
	var new_player = player.instance()
	new_player.set_name("Player")
	add_child(new_player)
	$Player.start(Vector2(64, 64))
	$Player.connect( "playerdeath", self , "_on_Player_playerdeath")
	$Player.connect( "shoot", self, "_on_Player_shoot")
	player_is_alive = true


func _on_RespawnTimer_timeout():
	respawn()

func _on_door_teleport():
	for i in get_children():
		if is_in_group("enemies"):
			i.queue_free()
	$Player.queue_free()
	#$Level/TestWorld.queue_free()
	$Level.add_child(secondworld)