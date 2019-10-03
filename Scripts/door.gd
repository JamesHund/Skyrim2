extends Node2D

signal teleport(level, pos)

export(String) var level
export(Vector2) var pos

var enterable = false
var contains_player
var cooldown_gui

#runs on initialization, starts teleport cooldown timer
func _ready():
	$CooldownTimer.start()
	cooldown_gui = get_tree().get_root().get_node("Main/GUI/TeleporterCooldown")

#Called when area is entered and attempts teleport if entered by player
#Takes in instance as a parameter
func _on_Area2D_body_entered( body ):
	if body.is_in_group("players"):
		contains_player = true
	_attempt_teleport()
	
#Checks if enterable and contains_player are true then teleports player
#Else shows the cooldown_gui
func _attempt_teleport():
	if enterable and contains_player:
		enterable = false
		emit_signal("teleport", level, pos)
		print("teleporting")
	elif contains_player:
		cooldown_gui._show_cooldown($CooldownTimer)
		
#Called when EnteredTimer is out and attempts teleport
func _on_EnteredTimer_timeout():
	enterable = true
	_attempt_teleport()

#Takes in instance as a parameter and hides teleporter cooldown gui if player exits area
func _on_Area2D_body_exited(body):
	if (body.is_in_group("players")):
		contains_player = false
		cooldown_gui._hide_cooldown()
		
