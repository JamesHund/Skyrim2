extends Area2D

var direction
var source
var group
var damage
var speed
var speedtest

func _ready():
	pass
	
func _initialize(dir, src, dmg, spd, sprd):
	position = src.position
	source = src
	damage = dmg
	speed = spd
	if src.is_in_group("players"):
		group = "players"
	else:
		group = "enemies"
	direction = polar2cartesian(1, cartesian2polar(dir.x,dir.y).y + deg2rad(rand_range(0,sprd)-sprd/2))
	rotation = cartesian2polar(dir.x,dir.y).y
	$DecayTimer.start()
	speedtest = 0

func _process(delta):
	position += direction*speed*delta

func _on_DecayTimer_timeout():
	hide()
	queue_free()

func _on_Projectile_body_entered( body ):
	if body.is_in_group("characters"):
		if !body.is_in_group(group):
			body.damage(damage)
			if body.is_in_group("enemies"):
				body._apply_impulse(direction*speed)
			hide()
			queue_free()
	else:
		hide()
		queue_free()
