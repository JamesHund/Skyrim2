extends MarginContainer

func _update_merchant(var NPC):
	if !NPC.merchant:
		printerr("NPC " + NPC.npc_name + " is not merchant")

func _set_stats(var id):
	var info_array = ItemUtils._get_item_info_string(id)
	var info = ItemData.items[id].name + info_array[0] + info_array[1]
	$MainContainer/VBoxContainer/HBoxContainer/StatsContainer/RightMargin/Stats.set_bbcode_text(info)