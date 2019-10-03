extends Node2D

#Preload Scenes to Instantiate
onready var projectile = preload("res://Scenes//Entities//Projectiles//Projectile.tscn")
onready var enemy = preload("res://Scenes//Entities//Characters//Enemy.tscn")
onready var player = preload("res://Scenes//Entities//Characters//Player.tscn")
onready var spawnarea = preload("res://Scenes//LevelParts//SpawnArea.tscn")
onready var NPC = preload("res://Scenes//Entities//Characters//NPC.tscn")
onready var worlditem = preload("res://Scenes/Entities/WorldItem.tscn")

#Fields
var player_is_alive
onready var enemy_list = []
onready var NPC_list = []
onready var item_list = []
var lvl #stores level resource to be loaded
#var default_grid #stores grid of tilemap
#var tilemap_path

#runs before children nodes are initialized and initializes main_scene reference
func _enter_tree():
	Global.main_scene = self
	
#runs when entering SceneTree, shows main menu
func _ready():
	$GUI._show_MainMenu()
	
#-------Level swapping and player death--------------

#This method is called when a new game is created, spawning the player, 
#loading the default level, giving the player a starting weapon and
#wiping the save file
func _new_game():
	_respawn()
	_load_level("testworld", $Player.position)
	$Inventory._create_and_add_item(6,1)
	SaveHandler._save()
	
#This method is called when a game is continued spawning the player, 
#loading the default level, and restoring inventory and quest contents
#from save file
func _continue_game():
	SaveHandler._load_from_save()
	_respawn()
	_load_level("testworld", $Player.position)
	
#This method removes any objects from the scene that are level specific
#It instances the level from a tscn file, sends the player to position pos
#And initializes all level components: NPC's, SpawnArea's, Chests and teleporters
func _load_level(level, pos):
	for i in get_children():
		if !i.is_in_group("main"):
			i.queue_free()
	for i in $Level.get_children():
		i.queue_free()
	lvl = load ("res://Scenes/Levels/" + level + ".tscn")
	var new_level = lvl.instance()
	$Level.call_deferred("add_child",new_level)
	$Player.position = pos
	$Player._clear_interactables()
	#Creates a small delay to allow for nodes to be deleted---
	yield(get_tree().create_timer(0.0002), "timeout")
	_initializeSpawnAreas()
	_initialize_NPCs()
	_initialize_teleporters()
	_initialize_loot_chests()
	
#Instances a new player object and connects all player signals to
#Their relevant methods in other classes
#It also updates the player's gear to match that of the inventory
func _respawn():
	var new_player = player.instance()
	new_player.set_name("Player")
	player_is_alive = true
	add_child(new_player)
	$GUI._enable()
	$Player._start(Vector2(1504, 512))
	$Player.connect( "playerdeath", self , "_on_Player_playerdeath")
	$Player.connect( "shoot", self, "_on_Player_shoot")
	$Player.connect( "health_update", $GUI/PlayerInfo, "_set_health")
	$Player.connect( "weapon_update", $GUI/PlayerInfo, "_set_weapon")
	$Player._respawn_init()
	$Player.connect("pickupitem", $Inventory, "_add_world_item")
	$GUI/DevTools.connect("godmode", $Player, "_toggle_godmode")
	$Player.connect("reload", $GUI, "_show_reload")
	$Player.connect("reload_finished", $GUI, "_hide_reload")
	$Player.connect("heal", $GUI, "_show_healing")
	$Inventory._update_player_gear()
	
#----------Initializing Level Parts-------------

#Connects all teleporter signals to their relevant methods in the main class
func _initialize_teleporters():
	var teleporters = get_tree().get_nodes_in_group("teleport")
	for Teleporter in teleporters:
		Teleporter.connect("teleport",self,"_on_Teleporter_teleport")

#Connects all NPC signals to their relevant methods in the main class
func _initialize_NPCs():
	var NPCs = get_tree().get_nodes_in_group("NPC")
	for NPC in NPCs:
		NPC.connect("interacted",self,"_on_NPC_interacted")

#Connects all SpawnArea signals to their relevant methods in the main class
func _initializeSpawnAreas():
	var spawnareas = get_tree().get_nodes_in_group("spawnarea")
	for SpawnArea in spawnareas:
		SpawnArea.connect("spawn",self,"_on_SpawnArea_spawn")
		print("connected spawnarea")

#Connects all LootChest signals to their relevant methods in the main class
func _initialize_loot_chests():
	var chests = get_tree().get_nodes_in_group("lootchest")
	for chest in chests:
		chest.connect("dropitem",self,"_on_loot_chest_opened")

#----------------Projectiles---------------------
#This method is called when the player emits the shoot signal
#It takes damage, speed, spread and projectile count and
#instantiates a new projectile from the player's origin in 
#the direction of the mouse cursor
func _on_Player_shoot(damage, speed, spread, projectile_count):
	for i in range(projectile_count):
		var new_projectile = projectile.instance()
		add_child(new_projectile)
		new_projectile._initialize(get_global_mouse_position()-$Player.position, $Player, damage, speed, spread)
		
#This is called when the enemy emits the shoot signal it takes
#in an enemy instance, and instantiates a new projectile from
#the enemy's position in the direction of the player
func _on_Enemy_shoot(instance):
	if player_is_alive:
		var new_projectile = projectile.instance()
		add_child(new_projectile)
		new_projectile._initialize($Player.position-instance.position, instance, 2, 1000, 5)
		
#-------------Spawning characters---------------

#This method spawns either an enemy or an NPC depending on type
#passed at position pos. It also connects their signals to methods in
#the main class.
func _spawn_character(type,pos):
	if type==9: #Enemy
		var new_enemy = enemy.instance()
		enemy_list.append(new_enemy)
		$Level.add_child(new_enemy)
		new_enemy.connect( "shoot", self, "_on_Enemy_shoot")
		new_enemy.connect("death",self, "_on_Enemy_death")
		new_enemy._start(pos)
	elif type<9:
		NPC_list.append(NPC.instance())
		$Level.add_child(NPC_list[NPC_list.size()-1])
		NPC_list[NPC_list.size()-1]._start(type,pos)
		NPC_list[NPC_list.size()-1].connect("interacted", self, "_on_NPC_interacted")

#This method is run when a SpawnArea emits a spawn signal.
#It takes in the position of the spawn area, the spawn areas extents
#and the type of character to spawn. It will spawn the character in a
#random position within the spawn area's extents
func _on_SpawnArea_spawn(pos, extents,type):
	var x = rand_range(0, extents.x)
	var y = rand_range(0, extents.y)
	var spawnpos = Vector2(pos.x + x, pos.y + y)
	_spawn_character(type,spawnpos)	
		
#-------------Items------------------------
	
#Instantiates a world item with id and stacksize passed in at position pos.
func _spawn_world_item_id(var id, var stacksize, var pos):
	print("world item added")
	var new_item = worlditem.instance()
	$Level.add_child(new_item)
	new_item._initialize(id,stacksize,pos,0.3)
	item_list.append(new_item)
	
#Same as the above method but takes in an item instead of id and stacksize
func _spawn_world_item(var item, var pos):
	_spawn_world_item_id(item.id,item.stack_size,pos)

#spawn world item with custom pickupcooldown
func _spawn_world_item_pickup(var item, var pos, var pickupcooldown): 
	var new_item = worlditem.instance()
	$Level.add_child(new_item)
	new_item._initialize(item.id,item.stack_size,pos,pickupcooldown)
	item_list.append(new_item)

#This method is called when a LootChest emits the opened signal
#It takes in a list of items and spawns them at a random offset from pos
func _on_loot_chest_opened(var items, var pos):
	for item in items:
		var random_pos = pos + polar2cartesian(rand_range(2, 100), rand_range(0,360))
		_spawn_world_item(item,random_pos)
		
#----------------Interaction---------------

#This method is called when an NPC is interacted with, taking in an NPC
#instance as a parameter. It checks whether the NPC is a quest giver or a
#merchant and opens the relevant GUI screen.
func _on_NPC_interacted(NPC):
	if NPC.merchant:
		$GUI._show_MerchantScreen(NPC)
	else:
		$GUI._show_QuestDialogue(NPC)

#----------------Signals-------------------

#This method is called when an enemy dies, spawning a coin at position pos.
func _on_Enemy_death(var pos):
	_spawn_world_item_id(26, 1, pos)

#This method is called when a teleporter emits the teleport signal, calling
#the loadworld method with the level and pos defined in the teleporter object
func _on_Teleporter_teleport(level, pos):
	_load_level(level,pos)

#This method called when the player dies, loading the default level, temporarily
#disabling the GUI and starting the respawn timer
func _on_Player_playerdeath():
	_load_level("testworld", $Player.position)
	$GUI._disable()
	player_is_alive = false
	$RespawnTimer.start()

#This method is called when Inventory emits the dropitem signal, spawning a world
#item from 'item' parameter at the player's position with a pickup cooldown
func _on_Inventory_dropitem(var item):
	_spawn_world_item_pickup(item, _get_Player_position(), 3)

#Timers
#Called when RespawnTimer runs out, respawning player
func _on_RespawnTimer_timeout():
	_respawn()
	
#-----------Covenience---------------

#Returns the player object if player is alive else returning null
func _get_player():
	if player_is_alive:
		return $Player
	return null

#Returns the player position as a Vector2 if player is alive else returning null
func _get_Player_position():
	if player_is_alive:
		return $Player.position
	else:
		return null

#Calls _continue_game when Continue Game is clicked in main menu
func _on_MainMenu_continue_game():
	_continue_game()
