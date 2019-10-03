extends Item

class_name QuestItem, "res://Scripts/Items/QuestItem.gd"

var quest_id

func _ready():
	pass

#initializes variables
func _init(var _id, var _item_name, var _quest_id). (_id, _item_name, 4, 1, 1):
	quest_id = _quest_id
