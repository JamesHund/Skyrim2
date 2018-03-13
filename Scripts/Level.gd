extends Node

onready var spawnarea = preload("res://Scenes//LevelParts//SpawnArea.tscn")
signal spawn_entity(type,pos)
signal next_level

func _ready():
	_initialize()
		
func _initialize():
	var spawnareas = get_tree().get_nodes_in_group("spawnarea")
	for SpawnArea in spawnareas:
		SpawnArea.connect("spawn",self,"_on_SpawnArea_spawn")
		
func _on_SpawnArea_spawn(pos, extents,type):
	
	var x = rand_range(0, extents.x)
	var y = rand_range(0, extents.y)
	var spawnpos = Vector2(pos.x + x, pos.y + y)
	emit_signal("spawn_entity",type,spawnpos)

	

