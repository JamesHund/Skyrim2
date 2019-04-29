extends Node2D

#Preload Scenes to Instantiate
onready var projectile = preload("res://Scenes//Entities//Projectiles//Projectile.tscn")
onready var enemy = preload("res://Scenes//Entities//Characters//Enemy.tscn")
onready var player = preload("res://Scenes//Entities//Characters//Player.tscn")
onready var spawnarea = preload("res://Scenes//LevelParts//SpawnArea.tscn")
onready var mainnode = preload("res://Scenes//MainNode.tscn")
onready var NPC = preload("res://Scenes//Entities//Characters//NPC.tscn")
onready var worlditem = preload("res://Scenes/Entities/WorldItem.tscn")

#Fields
var player_is_alive
onready var enemy_list = []
onready var NPC_list = []
onready var item_list = []
var lvl #stores level resource to be loaded
var default_grid #stores grid of tilemap
var tilemap_path

func _ready():
	_initialize_level()
	_respawn()
	_load_level("testworld", $Player.position)
	
func _process(delta):
		pass
#-------Level swapping and player death--------------
func _load_level(level, pos):
	for i in get_children():
		if !i.is_in_group("main"):
			i.queue_free()
	for i in $Level.get_children():
		i.queue_free()
	lvl = load ("res://Scenes/Levels/" + level + ".tscn")
	var new_level = lvl.instance()
	$Level.call_deferred("add_child",new_level)
	default_grid = GridGenerator._gen_array_from_tilemap(new_level.get_node("TileMap"))
	tilemap_path = new_level.get_node("TileMap")
	$Player.position = pos
	$Player._clear_interactables()
	#TEMPORARY - Creates a small delay to allow for nodes to be deleted---
	yield(get_tree().create_timer(0.0001), "timeout")
	_initializeSpawnAreas()
	_initialize_NPCpointers()
	_initialize_teleporters()
	_initialize_loot_chests()
	

func _respawn():
	var new_player = player.instance()
	new_player.set_name("Player")
	player_is_alive = true
	add_child(new_player)
	$Player.start(Vector2(1504, 512))
	$Player.connect( "playerdeath", self , "_on_Player_playerdeath")
	$Player.connect( "shoot", self, "_on_Player_shoot")
	$Player.connect( "health_update", $GUI/PlayerInfo, "_set_health")
	$Player._respawn_init()
	$Player.connect("pickupitem", $Inventory, "_add_world_item")
	$GUI/DevTools.connect("godmode", $Player, "_toggle_godmode")
	
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
		print("connected spawnarea")
		
func _initialize_loot_chests():
	var chests = get_tree().get_nodes_in_group("lootchest")
	for chest in chests:
		chest.connect("dropitem",self,"_on_loot_chest_opened")

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
		
#-------------Spawning characters---------------
func _spawn_character(type,pos):
	print("spawn character")
	if type==9: #Enemy
		print("character is enemy")
		var new_enemy = enemy.instance()
		enemy_list.append(new_enemy)
		$Level.add_child(new_enemy)
		new_enemy.connect( "shoot", self, "_on_Enemy_shoot")
		new_enemy.connect("death",self, "_on_Enemy_death")
		new_enemy.start(pos)
	elif type<9:
		NPC_list.append(NPC.instance())
		$Level.add_child(NPC_list[NPC_list.size()-1])
		NPC_list[NPC_list.size()-1].start(type,pos)
		
func _on_SpawnArea_spawn(pos, extents,type):
	var x = rand_range(0, extents.x)
	var y = rand_range(0, extents.y)
	var spawnpos = Vector2(pos.x + x, pos.y + y)
	_spawn_character(type,spawnpos)	
		
#-------------Items------------------------
func _spawn_world_item(var item, var pos):
	_spawn_world_item_id(item.id,item.stack_size,pos)
	
func _spawn_world_item_id(var id, var stacksize, var pos):
	var new_item = worlditem.instance()
	$Level.add_child(new_item)
	new_item._initialize(id,stacksize,pos,0.3)
	item_list.append(new_item)
	
func _spawn_world_item_pickup(var item, var pos, var pickupcooldown): #spawn world item with custom pickupcooldown
	var new_item = worlditem.instance()
	$Level.add_child(new_item)
	new_item._initialize(item.id,item.stack_size,pos,pickupcooldown)
	item_list.append(new_item)
	
func _on_loot_chest_opened(var items, var pos):
	for item in items:
		var random_pos = pos + polar2cartesian(rand_range(2, 100), rand_range(0,360))
		_spawn_world_item(item,random_pos)
		
#----------------Signals-------------------

func _on_Enemy_death(var pos):
	_spawn_world_item_id(26, 1, pos)

func _on_Teleporter_teleport(level, pos):
	_load_level(level,pos)

func _on_Player_playerdeath():
	player_is_alive = false
	$RespawnTimer.start()
	
func _on_Inventory_dropitem(var item):
	_spawn_world_item_pickup(item, _get_Player_position(), 3)


#Timers
func _on_RespawnTimer_timeout():
	_respawn()
	

	
#-----------Covenience---------------

func _get_Player_position():
	if player_is_alive:
		return $Player.position
	else:
		return null


func _on_debugger_timeout():
	#print(player_ref.get_ref())
	pass
	


