extends Node2D

signal teleport(level, pos)

export(String) var level
export(Vector2) var pos

var enterable = false
var contains_player
var cooldown_gui

func _ready():
	$CooldownTimer.start()
	cooldown_gui = get_tree().get_root().get_node("Main/GUI/TeleporterCooldown")

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _on_Area2D_body_entered( body ):
	if body.is_in_group("players"):
		contains_player = true
	_attempt_teleport()
	

func _attempt_teleport():
	if enterable and contains_player:
		enterable = false
		emit_signal("teleport", level, pos)
		print("teleporting")
	elif contains_player:
		cooldown_gui._show_cooldown($CooldownTimer)
#		var gui = cooldown_gui.instance()
#		gui._show_cooldown($CooldownTimer)
		
		

func _on_EnteredTimer_timeout():
	enterable = true
	_attempt_teleport()

func _on_Area2D_body_exited(body):
	if (body.is_in_group("players")):
		contains_player = false
		cooldown_gui._hide_cooldown()
		
