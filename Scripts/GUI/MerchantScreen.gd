extends MarginContainer
onready var buttons = $MainContainer/VBoxContainer/HBoxContainer/ListContainer/VBoxContainer.get_children()
onready var inventory = Global.main_scene.get_node("Inventory")

onready var selected = -1

#called on entering SceneTree and hides MerchantScreen
func _ready():
	hide()

#takes an NPC as a parameter and populates the list with their inventory and displays their name
func _update_merchant(var NPC):
	if !NPC.merchant:
		printerr("NPC " + NPC.npc_name + " is not merchant")
	else:
		selected = -1
		var count = 0
		for item in NPC.inventory:
			buttons[count]._initialize(item)
			count += 1
		$MainContainer/VBoxContainer/MerchantInfo/MerchantName.set_text(NPC.npc_name)
		_reset_stats()

#sets the stats to show information about item with id
func _set_stats(var id):
	var info_array = ItemUtils._get_item_info_string_by_id(id)
	selected = id
	var info = "[right]" + ItemData.items[id].name + info_array[0] + "\n" + info_array[1] + "\nCost: " + str(ItemData.item_costs[id]) + " coins[/right]"
	$MainContainer/VBoxContainer/HBoxContainer/StatsContainer/VBoxContainer/RightMargin/Stats.bbcode_text = info

#sets stats to show nothing
func _reset_stats():
	$MainContainer/VBoxContainer/HBoxContainer/StatsContainer/VBoxContainer/RightMargin/Stats.bbcode_text = ""

#called when visibility of MerchantScreen is changed, pausing game if true
func _on_MerchantScreen_visibility_changed():
	if is_visible_in_tree():
		get_tree().set_pause(true)
	else:
		get_tree().set_pause(false)

#called when buy button is pressed and attempts to buy slected item
func _on_BuyButton_pressed():
	print("buy button")
	if selected != -1:
		inventory._buy(selected)
