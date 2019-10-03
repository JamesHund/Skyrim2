extends KinematicBody2D

signal shoot(instance)
signal death(pos)
#var type = "enemy"
#export(float)var MAXHP
onready var health = 100
onready var resistance = 100
onready var fireready = true
onready var processintervals = 0.0
var velocity
onready var knockback = false
var knockback_vector

#to do with pathfinding
#onready var tilemap_ref = get_tree().get_root().get_node("Main").tilemap_path#reference to tilemap node
#onready var grid = get_tree().get_root().get_node("Main").default_grid.duplicate(true)
#onready var gridsize = 128
#var current_path

#sets position to pos and makes enemy visible
func _start(pos):
	position = pos
	show()

#Called when entering scene, initializes firerate timer
func _ready():
	randomize()
	$FireRateTimer.set_wait_time(0.5)
	velocity = Vector2(randi()%3-1, randi()%3-1)
	
#Runs every processcycle, moves enemies and attempts to shoot
func _process(delta):
	processintervals += delta
	if(processintervals >= 2):
		#randomizes movement vector
		randomize()
		#_update_path()
		processintervals -= 2
		velocity = Vector2(randi()%3-1, randi()%3-1)
	if !knockback:
		move_and_slide(velocity.normalized()*4000*delta)
	else:
		move_and_slide((knockback_vector)+velocity.normalized()*1000*delta)
		knockback_vector *= 0.9*delta
	if fireready:
		emit_signal("shoot", self)
		$FireRateTimer.start()
		fireready = false

#damages enemy for value of hit
func damage(var hit):
	health -= hit * resistance/100
	if health <= 0:
		hide()
		queue_free()
		
#runs when firerate timer runs out and fireready
func _on_FireRateTimer_timeout():
	fireready = true
	
#emits death signal when enemy dies
func _exit_tree():
	emit_signal("death",position)
	
#func _update_path():
#	print("update path")
#	var enemy_tilemap_location = tilemap_ref.world_to_map(position)
#	var player_tilemap_location = tilemap_ref.world_to_map(get_tree().get_root().get_node("Main/Player").position)
#	var start_node = grid[enemy_tilemap_location.x][enemy_tilemap_location.y]
#	var end_node = grid[player_tilemap_location.x][player_tilemap_location.y]
#
#	var openSet = [] #nodes to be evaluated
#	var closedSet = [] #nodes that have been evaluated
#
#	openSet.append(start_node)
#
#	while !openSet.empty():
#		var current_node = openSet[0]
#
#		var j = 1
#		while j< openSet.size():
#			if openSet[j].get_fCost() < current_node.get_fCost() || openSet[j].get_fCost() == current_node.get_fCost() && openSet[j].hCost < current_node.hCost:
#				current_node = openSet[j]
#			j += 1
#
#		openSet.erase(current_node) #this may not work since vectors pass by value - may have use find() to delete
#		closedSet.append(current_node)
#
#		if current_node == end_node:
#			_retrace_path(start_node,end_node)
#			return
#
#		for neighbour in get_neighbours(current_node):
#			if(!neighbour.tileindex == 1 || closedSet.find(neighbour) != -1):
#				continue
#			print(current_node.gCost)
#			var new_movement_cost_to_neighbour = current_node.gCost + _get_distance(current_node,neighbour)
#			if new_movement_cost_to_neighbour < neighbour.gCost || openSet.find(neighbour) == -1:
#				neighbour.gCost = new_movement_cost_to_neighbour
#				neighbour.hCost = _get_distance(neighbour, end_node)
#				neighbour.parent = current_node
#
#				if openSet.find(neighbour) == -1:
#					openSet.append(neighbour)
#
#
#func _get_distance(var nodeA, var nodeB) -> int:
#	var distX = abs(nodeA.x - nodeB.x)
#	var distY = abs(nodeA.y - nodeB.y)
#	if distX < distY:
#		return distX*14 + 10*(distY-distX)
#	return distY*14 + 10*(distX-distY)
#
#func _retrace_path(var start_node, var end_node):
#	print("retrace path")
#	var path = []
#	var current_node = end_node
#	while current_node != start_node:
#		path.append(current_node)
#		current_node = current_node.parent
#	path.invert();
#	current_path = path
#
#
#func get_neighbours(var node) -> Array:
#	var neighbours = []
#
#	for x in range(-1,2):
#		for y in range(-1,2):
#			if x==0 && y == 0:
#				continue
#
#			var checkX = node.x + x
#			var checkY = node.y + y
#			if checkX >= 0 && checkX < gridsize && checkY >= 0 && checkY < gridsize:
#				neighbours.append(grid[checkX][checkY])
#	#print(str(node.x) + "," + str(node.y))
#	#print(neighbours.size())
#	return neighbours
	
#propels enemy in a direction as specified by vector
func _apply_impulse(var vector):
	knockback = true
	knockback_vector = vector.normalized()*100
	$KnockbackTimer.start()
	
	
#runs when knockback timer is complete and sets knockback to false
func _on_KnockbackTimer_timeout():
	knockback = false

