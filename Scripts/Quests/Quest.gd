extends Node

class_name Quest, "res://Scripts/Quests/Quest.gd"

var quest_state # 0 - Inactive | 1 - Active | 2 - Item Collected | 3 - Reward Collected (Complete)
var id
var NPC
var location_name
var location_direction
var quest_item
var reward #id of item given as reward
var difficulty #Scale of 1-5 , 1 being the easiest

func _init(var state):
	quest_state = state
