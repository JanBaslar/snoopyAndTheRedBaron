extends CharacterBody2D

@export var speed = 333
@export var rotation_speed = 3

var rotation_direction = 0
const bullet = preload("res://snoopy_bullet_scene.tscn")

func get_input():
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
	var b = bullet.instantiate() as Node2D
	owner.add_child(b)
	b.transform = $Marker2D.global_transform

func _physics_process(delta):
	get_input()
	rotation += rotation_direction * rotation_speed * delta
	correct_rotation()
	shoot()
	move_and_slide()
