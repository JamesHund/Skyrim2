extends Node

var quest_gui
var quests

func _ready():
	pass # Replace with function body.

func _activate_quest():
	pass
	
func _quest_item_collected(var item):
	pass
	
func _complete_quest():
	pass
	
func _set_quest_gui(var ref):
	quest_gui = ref
	_update_quest_gui()
	
func _update_quest_gui():
	pass