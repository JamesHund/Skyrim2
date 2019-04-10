extends KinematicBody2D

onready var pNode = preload("res://Scenes//Pathfinding//pNode.tscn")
signal shoot(instance)
#var type = "enemy"
#export(float)var MAXHP
var health
var resistance = 100
var fireready
var processintervals
var velocity

#to do with pathfinding
var tilemap_ref #reference to tilemap node
var current_path
var grid
var gridsize = 128

func start(pos):
	position = pos
	show()

func _ready():
	$FireRateTimer.set_wait_time(0.3)
	health = 10
	fireready = true
	processintervals = 0.0
	velocity = Vector2(randi()%3-1, randi()%3-1)
	grid = get_tree().get_root().get_node("Main").grid.duplicate(true)
	tilemap_ref = get_tree().get_root().get_node("Main").tilemap_path

func _process(delta):
	processintervals += delta
	if(processintervals >= 1):
		_update_path()
		processintervals -= 1
	move_and_collide(velocity.normalized()*delta*100)
	if fireready:
		emit_signal("shoot", self)
		$FireRateTimer.start()
		fireready = false

func damage(var hit):
	health -= hit * resistance/100
	if health <= 0:
		hide()
		queue_free()
		

func _on_FireRateTimer_timeout():
	fireready = true
	
	
func _update_path():
	var enemy_tilemap_location = tilemap_ref.world_to_map(position)
	var player_tilemap_location = tilemap_ref.world_to_map(get_tree().get_root().get_node("Main/Player").position)
	var start_node = grid[enemy_tilemap_location.x][enemy_tilemap_location.y]
	var end_node = grid[player_tilemap_location.x][player_tilemap_location.y]
	
	var openSet = [] #nodes to be evaluated
	var closedSet = [] #nodes that have been evaluated
	
	openSet.append(start_node)
	
	while !openSet.empty():
		var current_node = openSet[0]
		for node in openSet:
			if node.get_fCost() < current_node.get_fCost() || node.get_fCost() == current_node.get_fCost() && node.hCost < current_node.hCost:
				current_node = node
				
		openSet.erase(current_node) #this may not work since vectors pass by value - may have use find() to delete
		closedSet.append(current_node)
		
		if current_node == end_node:
			_retrace_path(start_node,end_node)
			return
			
		for neighbour in get_neighbours(current_node):
			if(!neighbour.tileindex == 1 || closedSet.find(neighbour) != -1):
				continue
			
			var new_movement_cost_to_neighbour = current_node.gCost + _get_distance(current_node,neighbour)
			if new_movement_cost_to_neighbour < neighbour.gCost || openSet.find(neighbour) == -1:
				neighbour.gCost = new_movement_cost_to_neighbour
				neighbour.hCost = _get_distance(neighbour, end_node)
				neighbour.parent = current_node
				
				if openSet.find(neighbour) == -1:
					openSet.append(neighbour)
		
func _get_distance(var nodeA, var nodeB) -> int:
	var distX = abs(nodeA.x - nodeB.x)
	var distY = abs(nodeA.y - nodeB.y)
	if distX < distY:
		return distX*14 + 10*(distY-distX)
	return distY*14 + 10*(distX-distY)
	
func _retrace_path(var start_node, var end_node):
	var path = []
	var current_node = end_node
	while current_node != start_node:
		path.append(current_node)
		current_node = current_node.parent
	path.invert();
	current_path = path
	
	
func get_neighbours(var node) -> Array:
	var neighbours = []
	
	for x in range(-1,2):
		for y in range(-1,2):
			if x==0 && y == 0:
				continue
				
			var checkX = node.x + x
			var checkY = node.y + y
			if checkX >= 0 && checkX < gridsize && checkY >= 0 && checkY < gridsize:
				neighbours.append(grid[checkX][checkY])
			
	return neighbours
	

