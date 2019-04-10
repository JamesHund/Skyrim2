extends Node2D

#Preload Scenes to Instantiate
onready var projectile = preload("res://Scenes//Entities//Projectiles//Projectile.tscn")
onready var enemy = preload("res://Scenes//Entities//Characters//Enemy.tscn")
onready var player = preload("res://Scenes//Entities//Characters//Player.tscn")
onready var spawnarea = preload("res://Scenes//LevelParts//SpawnArea.tscn")
onready var mainnode = preload("res://Scenes//MainNode.tscn")
onready var NPC = preload("res://Scenes//Entities//Characters//NPC.tscn")

#Fields
var player_is_alive
var enemy_list = []
var NPC_list = []
var lvl
var default_grid #stores grid of tilemap
var tilemap_path
var player_ref #weak reference that can be used to check for the player's existence

func free_all_subnodes(node, group): #obsolete
	for n in node.get_children():
		if n.get_child_count() > 0:
			free_all_subnodes(n, group)
		elif !n.is_in_group(group):
			n.queue_free()
			
func createTimer(_time,_oneshot,_name): #creates a timer
	var t = Timer.new()
	t.set_wait_time(_time)
	t.set_one_shot(_oneshot)
	t.set_name(_name)
	self.add_child(t)
	t.start()
	return t

#-------Level swapping and player death--------------
func _ready():
	_initialize_level()
	player_is_alive = true
	player_ref = weakref($Player)
	_load_level("testworld", $Player.position)
	$Player.start(Vector2(1504, 512))
	$TeleportTimer.start();
	
func _process(delta):
		pass
		
func _load_level(level, pos):
	for i in get_children():
		if !i.is_in_group("main"):
			i.queue_free()
	for i in $Level.get_children():
		i.queue_free()
	lvl = load ("res://Scenes/Levels/" + level + ".tscn")
	var new_level = lvl.instance()
	$Level.call_deferred("add_child",new_level)
	default_grid = $GridGenerator._gen_array_from_tilemap(new_level.get_node("TileMap"))
	tilemap_path = new_level.get_node("TileMap")
	#tilemap_ref = get_node("Level/" + level.get_name() + "/TileMap")
	$Player.position = pos
	#TEMPORARY - Creates a small delay to allow for nodes to be deleted---
	yield(get_tree().create_timer(0.0001), "timeout")
	print("initializing spawn areas and NPC pointers")
	_initializeSpawnAreas()
	_initialize_NPCpointers()
	

func _respawn():
	var new_player = player.instance()
	new_player.set_name("Player")
	player_is_alive = true
	player_ref = weakref($Player)
	add_child(new_player)
	$Player.start(Vector2(64, 64))
	$Player.connect( "playerdeath", self , "_on_Player_playerdeath")
	$Player.connect( "shoot", self, "_on_Player_shoot")
	
#----------Initializing Level Parts-------------
func _initialize_level():
	var Level = mainnode.instance()
	Level.set_name("Level")
	add_child(Level)
	
func _initialize_teleporters():
	var teleporters = get_tree().get_nodes_in_group("teleport")
	for Teleporter in teleporters:
		Teleporter.connect("teleport",self,"_on_Teleporter_teleport")

func _initialize_NPCpointers():
	var pointers = get_tree().get_nodes_in_group("NPCpointer")
	for NPCpointer in pointers:
		_spawn_character(NPCpointer.type, NPCpointer.position)
		NPCpointer.queue_free()
		
	
func _initializeSpawnAreas():
	var spawnareas = get_tree().get_nodes_in_group("spawnarea")
	for SpawnArea in spawnareas:
		SpawnArea.connect("spawn",self,"_on_SpawnArea_spawn")

#----------------Projectiles---------------------
func _on_Player_shoot():
	var new_projectile = projectile.instance()
	add_child(new_projectile)
	new_projectile._initialize(get_global_mouse_position()-$Player.position, $Player)

func _on_Enemy_shoot(instance):
	if player_is_alive:
		var new_projectile = projectile.instance()
		add_child(new_projectile)
		new_projectile._initialize($Player.position-instance.position, instance)
		
#-------------Initializing characters---------------
func _spawn_character(type,pos):
	if type==9: #Enemy
		enemy_list.append(enemy.instance())
		$Level.add_child(enemy_list[enemy_list.size()-1])
		enemy_list[enemy_list.size()-1].connect( "shoot", self, "_on_Enemy_shoot")
		enemy_list[enemy_list.size()-1].start(pos)
	elif type<9:
		NPC_list.append(NPC.instance())
		$Level.add_child(NPC_list[NPC_list.size()-1])
		NPC_list[NPC_list.size()-1].start(type,pos)
		
#----------------Signals-------------------
		
func _on_Teleporter_teleport(level, pos):
	print("yyee")
	_load_level(level,pos)
	$TeleportTimer.start()

func _on_SpawnArea_spawn(pos, extents,type):
	
	var x = rand_range(0, extents.x)
	var y = rand_range(0, extents.y)
	var spawnpos = Vector2(pos.x + x, pos.y + y)
	_spawn_character(type,spawnpos)	

func _on_Player_playerdeath():
	player_is_alive = false
	$RespawnTimer.start()

#Timers
func _on_RespawnTimer_timeout():
	_respawn()


func _on_TeleportTimer_timeout():
	_initialize_teleporters()
	
#-----------Covenience---------------

func _get_Player_position():
	if player_is_alive:
		return $Player.position
	else:
		return null


func _on_debugger_timeout():
	#print(player_ref.get_ref())
	pass
