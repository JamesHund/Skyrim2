extends Node

#contains node information that pertains to pathfinding

var gCost
var hCost
var parent
var pos
var x
var y
var tileindex

func init(_x,_y,_i):
	tileindex = _i
	pos = Vector2(_x,_y)
	x = _x
	y = _y

func get_fCost():
	return gCost + hCost
