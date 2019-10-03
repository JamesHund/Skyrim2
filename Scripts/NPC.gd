extends KinematicBody2D

signal interacted(NPC)

export(int) var id
onready var merchant = false
var npc_name
var inventory

#runs when NPC enters tree, starts npc
func _ready():
	_start(id,position)
	
#starts NPC at position, assigns sprite, label and sets inventory if NPC merchant
func _start(var id, var pos):
	position = pos
	if id > NPCdata.npc_list.size():
		printerr("NPC ID out of range")
		return
	npc_name = NPCdata.npc_list[id].get("name")
	$NameLabel.set_text(npc_name)
	if NPCdata.npc_list[id].get("merchant") != null:
		merchant = true
		inventory  = NPCdata.npc_list[id].get("merchant")
	$Sprites.animation = str(id)
	
#emits interacted signal
func _interact():
	print(npc_name, " interacted with")
	emit_signal("interacted",self)
	
	