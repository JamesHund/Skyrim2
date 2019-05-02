extends MarginContainer

func _update_merchant(var NPC):
	if !NPC.merchant:
		printerr("NPC " + NPC.npc_name + " is not merchant")
	