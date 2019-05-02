extends Node

class_name NPCdata, "res://Scripts/NPCdata.gd"

var npc_list

func _ready():
	var file = File.new()
	file.open("res://data/npc_data.json", File.READ)
	var content = file.get_as_text()
	file.close()
	var result = JSON.parse(content)
	if result.error != OK:
		printerr("error parsing npc_data.json")
		print(result.get_error_line())
		print(result.get_error_string())
		return null
	else:
		print("npc_data has been parsed correctly")
	npc_list = result.get_result().get("Characters")
	
