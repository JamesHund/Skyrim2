extends Node2D

onready var projectile = preload("res://Scenes//Projectile.tscn")
onready var enemy = preload("res://Scenes//Enemy.tscn")
onready var player = preload("res://Scenes//Player.tscn")

var player_is_alive
var enemy_list = []

func _ready():
	$Player.start(Vector2(64, 64))
	player_is_alive = true
	$Level.connect("spawn_entity",self,"_on_Level_spawn_entity")
	
func _process(delta):
		pass

func _on_Player_shoot():
	var new_projectile = projectile.instance()
	add_child(new_projectile)
	new_projectile._initialize(get_global_mouse_position()-$Player.position, $Player)

func _on_Enemy_shoot(instance):
	if player_is_alive:
		var new_projectile = projectile.instance()
		add_child(new_projectile)
		new_projectile._initialize($Player.position-instance.position, instance)


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

func _on_Level_spawn_entity(type,pos):
	print(type)
	if type==1:
		enemy_list.append(enemy.instance())
		add_child(enemy_list[enemy_list.size()-1])
		enemy_list[enemy_list.size()-1].connect( "shoot", self, "_on_Enemy_shoot")
		enemy_list[enemy_list.size()-1].start(pos)
		print("Enemy Spawned")
		print(pos)