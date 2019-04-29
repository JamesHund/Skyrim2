extends MarginContainer

onready var inventory = get_tree().get_root().get_node("Main/Inventory")

#store rectangles that determine regions of the inventory
var items_region
var gear_region

#values used to calculate how items move around the inventory
onready var slot_size_item = get_node("MainContainer/VBoxContainer/GridSeperator/Items/00").rect_size
onready var slot_size_gear = get_node("MainContainer/VBoxContainer/GridSeperator/Gear/05").rect_size
onready var item_v_seperation = get_node("MainContainer/VBoxContainer/GridSeperator/Items").get("custom_constants/vseparation")
onready var item_h_seperation = get_node("MainContainer/VBoxContainer/GridSeperator/Items").get("custom_constants/hseparation")
onready var gear_v_seperation = get_node("MainContainer/VBoxContainer/GridSeperator/Gear").get("custom_constants/vseparation")
onready var gear_h_seperation = get_node("MainContainer/VBoxContainer/GridSeperator/Gear").get("custom_constants/hseparation")


func _ready():
	hide()
	_sell_button_set_visible(false)
	_connect_inventory_items()
	var items_region_node = $MainContainer/VBoxContainer/GridSeperator/Items
	var gear_region_node = $MainContainer/VBoxContainer/GridSeperator/Gear
	items_region = Rect2(items_region_node.get_global_position(),items_region_node.get_size())
	gear_region = Rect2(gear_region_node.get_global_position(),gear_region_node.get_size())
	_set_item_info("","","")
	

func _process(delta):
	pass
	

func _change_sprite(var grid_pos, var id, var stacksize): #takes vector2 and id
	if grid_pos.x == 5:
		get_node("MainContainer/VBoxContainer/GridSeperator/Gear/" + str(grid_pos.y) + "5/InventoryItem")._set_sprite(id,stacksize)
	else:
		get_node("MainContainer/VBoxContainer/GridSeperator/Items/" + str(grid_pos.y) + str(grid_pos.x) + "/InventoryItem")._set_sprite(id,stacksize)
		
func _connect_inventory_items():
	for node in get_tree().get_nodes_in_group("inventoryitem"):
		node.connect("released",get_node(""), "_on_InventoryItem_released") 

func _set_item_info(var name, var type, var info):
	$MainContainer/VBoxContainer/ItemInfo/HBoxContainer/VBoxContainer/ItemName.set_text(name)
	$MainContainer/VBoxContainer/ItemInfo/HBoxContainer/VBoxContainer/ItemType.set_text(type)
	$MainContainer/VBoxContainer/ItemInfo/HBoxContainer/StatsContainer/ItemStats.set_text(info)

func _on_InventoryItem_released(pos, grid):
	if items_region.has_point(pos):
		var pos_relative_to_item_region = pos - items_region.position 
		var x = floor((pos_relative_to_item_region.x+item_v_seperation/2)/(slot_size_item.x+item_v_seperation))
		var y = floor((pos_relative_to_item_region.y+item_h_seperation/2)/(slot_size_item.x+item_h_seperation))
		if grid != Vector2(x,y):
			inventory._move_item(grid,Vector2(x,y))
		inventory._set_selected(Vector2(x,y))
		
	elif gear_region.has_point(pos):
		var pos_relative_to_gear_region = pos-gear_region.position
		var x = 5
		var y = floor((pos_relative_to_gear_region.y+gear_h_seperation/2)/(slot_size_gear.x+gear_h_seperation))
		if grid != Vector2(x,y):
			inventory._move_item(grid,Vector2(x,y))
		else:
			inventory._set_selected(Vector2(x,y))

	#Calculate grid pos of destination based on pos
	#Call inventory move_item with both grid pos

func _sell_button_set_visible(var visibilty):
	var sell_container = $MainContainer/VBoxContainer/ItemInfo/HBoxContainer/VBoxContainer/SellDropContainer/SellContainer
	if visibilty:
		for child in sell_container.get_children():
			child.show()
	else:
		for child in sell_container.get_children():
			child.hide()

func _on_DropButton_pressed():
	inventory._drop_selected()


func _on_SellButton_pressed():
	pass # Replace with function body.
