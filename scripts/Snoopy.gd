extends CharacterBody2D

@export var speed = Global.PLAYER_SPEED
@export var rotation_speed = Global.ROTATION_SPEED

var rotation_direction = 0
const bullet = preload("res://snoopy_bullet_scene.tscn")

func get_input():
	"""Handles player rotation"""
	rotation_direction = Input.get_axis("snoopy_left", "snoopy_right")
	velocity = transform.x * speed

func correct_rotation():
	"""Corrects direction if player moves out of boundaries"""
	if position.x < Boundary.LEFT:
		rotation_degrees = 0
	elif position.x > Boundary.RIGHT:
		rotation_degrees = 180
	elif position.y < Boundary.TOP:
		rotation_degrees = 90
	elif position.y > Boundary.BOTTOM:
		rotation_degrees = 270

func shoot():
	"""Shoot if key pressed and you can"""
	if Input.is_action_pressed("snoopy_shoot") and $ShootTimer.get_time_left() == 0:
		$ShootTimer.start()
		var b = bullet.instantiate()
		owner.add_child(b)
		b.transform = $Muzzle.global_transform

func _physics_process(delta):
	"""Player game loop"""
	get_input()
	rotation += rotation_direction * rotation_speed * delta
	correct_rotation()
	shoot()
	move_and_slide()
