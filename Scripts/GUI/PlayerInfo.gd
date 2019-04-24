extends MarginContainer

func _ready():
	pass
	
func _set_health(var value):
	$VBoxContainer/BottomBar/HealthContainer/HBoxContainer/CenterContainer/TextureProgress.set_value(value)
	$VBoxContainer/BottomBar/HealthContainer/HBoxContainer/CenterContainer2/Health.set_text(str(value))
