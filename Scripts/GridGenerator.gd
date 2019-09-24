extends Node

class_name GridGenerator, "res://Scripts/GridGenerator.gd"
#Utility Class - Generates a grid of Pathfinding-Nodes (pNodes) from a Tilemap

static func _gen_array_from_tilemap(var tilemap):
	var used_cells = tilemap.get_used_cells()
	
	var grid = []
	for x in range(256): #max area 128*128, can change
		grid.append([])
		grid[x].resize(256)
		
	var k = 0
	for cell in used_cells:
		var node = pNode.new(cell.x,cell.y, tilemap.get_cellv(cell))
		grid[cell.x][cell.y] =  node
		k += 1
			
	return grid
		
