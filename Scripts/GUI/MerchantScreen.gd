extends MarginContainer
onready var buttons = $MainContainer/VBoxContainer/HBoxContainer/ListContainer/VBoxContainer.get_children()

var selected

func _ready():
	hide()

func _update_merchant(var NPC):
	if !NPC.merchant:
		printerr("NPC " + NPC.npc_name + " is not merchant")
	else:
		var count = 0
		for item in NPC.inventory:
			buttons[count]._initialize(item)
			count += 1
		$MainContainer/VBoxContainer/MerchantInfo/MerchantName.set_text(NPC.npc_name)
		_reset_stats()

func _set_stats(var id):
	var info_array = ItemUtils._get_item_info_string_by_id(id)
	var selected = id
	var info = "[right]" + ItemData.items[id].name + info_array[0] + "\n" + info_array[1] + "\nCost: " + str(ItemData.item_costs[id]) + " coins[/right]"
	$MainContainer/VBoxContainer/HBoxContainer/StatsContainer/VBoxContainer/RightMargin/Stats.bbcode_text = info
	
func _reset_stats():
	$MainContainer/VBoxContainer/HBoxContainer/StatsContainer/VBoxContainer/RightMargin/Stats.bbcode_text = ""
	
func _on_MerchantScreen_visibility_changed():
	if is_visible_in_tree():
		get_tree().set_pause(true)
	else:
		get_tree().set_pause(false)

func _on_BuyButton_pressed():
	pass # Replace with function body.
