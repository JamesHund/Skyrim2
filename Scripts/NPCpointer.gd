extends Node

export(int) var type
	
func _ready():
	hide()
	
func _exit_tree():
	print("NPCpointer of type " + str(type) + " has been deleted")

