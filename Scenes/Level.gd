extends Node
onready var spawnarea = preload("res://Scenes//SpawnArea.tscn")
signal spawn_entity(type,pos)

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	get_node("World/SpawnArea").connect("spawn",self,"_on_SpawnArea_spawn")

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_SpawnArea_spawn(spawn_area_shape,type):
	
	var x = rand_range(spawn_area_shape.x.y,spawn_area_shape.x.x)
	var y = rand_range(spawn_area_shape.y.y,spawn_area_shape.y.x)
	var pos = Vector2(spawn_area_shape.origin.x+x,spawn_area_shape.origin.y+y)
	emit_signal("spawn_entity",type,pos)
	