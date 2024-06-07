extends Area2D

var speed = Global.BULLET_SPEED

func remove_bullets_out_of_boundaries():
	"""Removes bullet if it is too far from player"""
	if position.x > Global.DEAD_AREA or position.y > Global.DEAD_AREA:
		queue_free()
		
func _physics_process(delta):
	"""Bullet game loop"""
	remove_bullets_out_of_boundaries()
	position -= transform.x * speed * delta
