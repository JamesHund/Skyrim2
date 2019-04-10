extends Node
onready var pNode = preload("res://Scenes//Pathfinding//pNode.tscn")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _gen_array_from_tilemap(var tilemap):
	var used_cells = tilemap.get_used_cells()
	
	var grid = []
	var k = 0
	for cell in used_cells:
		var node = pNode.instance()
		node.init(cell.x,cell.y, tilemap.get_cellv(cell))
		grid[cell.x][cell.y] =  node
		k += 1
			
	return grid
		
