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

func _init(var _id,var _NPC,var _location_name,var _location_direction,var _quest_item,var _reward,var _difficulty, var _quest_state):
	id = _id
	NPC = _NPC
	location_name = _location_name
	location_direction = _location_direction
	quest_item = _quest_item
	reward = _reward
	difficulty = _difficulty
	quest_state = _quest_state
