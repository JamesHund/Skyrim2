extends KinematicBody2D

var direction
var source
var group
var damage
var speed

#initializes variables, sets collision mask based on source and rotates object
func _initialize(dir, src, dmg, spd,sprd):
	position = src.position
	source = src
	damage = dmg
	speed = spd
	if src.is_in_group("players"):
		group = "players"
		set_collision_mask_bit(3,true)
	else:
		group = "enemies"
		set_collision_mask_bit(2,true)
	direction = polar2cartesian(1, cartesian2polar(dir.x,dir.y).y + deg2rad(rand_range(0,sprd)-sprd/2))
	rotation = cartesian2polar(dir.x,dir.y).y
	$DecayTimer.start()

#runs every physics frame and detects and handles collision
func _physics_process(delta):
	var collision = move_and_collide(direction*speed*delta)
	if collision:
		if collision.collider.is_in_group("characters"):
			if !collision.collider.is_in_group(group):
				collision.collider.damage(damage)
				if collision.collider.is_in_group("enemies"):
					collision.collider._apply_impulse(direction*speed*40)
				hide()
				queue_free()
		else:
			hide()
			queue_free()

#deletes projectile
func _on_DecayTimer_timeout():
	hide()
	queue_free()


