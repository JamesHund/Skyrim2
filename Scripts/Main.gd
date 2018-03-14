extends Node2D

#Preload Scenes to Instantiate
onready var projectile = preload("res://Scenes//Entities//Projectiles//Projectile.tscn")
onready var level = preload("res://Scenes//Level.tscn")
onready var enemy = preload("res://Scenes//Entities//Characters//Enemy.tscn")
onready var player = preload("res://Scenes//Entities//Characters//Player.tscn")

#Fields
var player_is_alive
var enemy_list = []

#Basic Functions
func _ready():
	$Player.start(Vector2(538, 320))
	player_is_alive = true
	$Level.connect("spawn_entity",self,"_on_Level_spawn_entity")
	_initialize_teleporters()
	
func _process(delta):
		pass

func respawn():
	var new_player = player.instance()
	new_player.set_name("Player")
	add_child(new_player)
	$Player.start(Vector2(64, 64))
	$Player.connect( "playerdeath", self , "_on_Player_playerdeath")
	$Player.connect( "shoot", self, "_on_Player_shoot")
	player_is_alive = true
	
func _initialize_teleporters():
	var teleporters = get_tree().get_nodes_in_group("teleport")
	for Teleporter in teleporters:
		Teleporter.connect("teleport",self,"_on_Teleporter_teleport")
	

#Signal functions

#Shooting Projectiles
func _on_Player_shoot():
	var new_projectile = projectile.instance()
	add_child(new_projectile)
	new_projectile._initialize(get_global_mouse_position()-$Player.position, $Player)

func _on_Enemy_shoot(instance):
	if player_is_alive:
		var new_projectile = projectile.instance()
		add_child(new_projectile)
		new_projectile._initialize($Player.position-instance.position, instance)
		
#Initializing entities
func _on_Level_spawn_entity(type,pos):
	if type==1:
		enemy_list.append(enemy.instance())
		add_child(enemy_list[enemy_list.size()-1])
		enemy_list[enemy_list.size()-1].connect( "shoot", self, "_on_Enemy_shoot")
		enemy_list[enemy_list.size()-1].start(pos)
		
func _on_Teleporter_teleport(level, pos):
	for i in get_children():
		if !i.is_in_group("main"):
			i.queue_free()
	for i in $Level.get_children():
		i.queue_free()
	var lvl = load ("res://Scenes/Levels/" + level + ".tscn")
	add_child(lvl.instance())
	$Player.position = pos
	$TeleportTimer.start()


func _on_Player_playerdeath():
	player_is_alive = false
	$RespawnTimer.start()

#Timers
func _on_RespawnTimer_timeout():
	respawn()


func _on_TeleportTimer_timeout():
	_initialize_teleporters()

