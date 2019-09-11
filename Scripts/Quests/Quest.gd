extends Node

class_name Quest, "res://Scripts/Quests/Quest.gd"

var quest_state # 0 - Inactive | 1 - Active | 2 - Item Collected | 3 - Reward Collected (Complete)
var quest_loca

func _init(var state):
	quest_state = state
