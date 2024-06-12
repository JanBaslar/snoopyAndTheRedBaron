extends CharacterBody2D

@export var speed = -Global.PLAYER_SPEED
@export var rotation_speed = Global.ROTATION_SPEED
var health = Global.HEALTH
var rotation_direction = 0
const bullet = preload("res://baron_bullet_scene.tscn")

func get_input():
	"""Handles player rotation"""
	rotation_direction = Input.get_axis("baron_left", "baron_right")
	velocity = transform.x * speed

func correct_rotation():
	"""Corrects direction if player moves out of boundaries"""
	if position.x < Boundary.LEFT:
		rotation_degrees = 180
	elif position.x > Boundary.RIGHT:
		rotation_degrees = 0
	elif position.y < Boundary.TOP:
		rotation_degrees = 270
	elif position.y > Boundary.BOTTOM:
		rotation_degrees = 90

func shoot():
	"""Shoot if key pressed and you can"""
	if Input.is_action_pressed("baron_shoot") and $ShootTimer.get_time_left() == 0:
		$BaronGunshot.play()
		$ShootTimer.start()
		var b = bullet.instantiate()
		owner.add_child(b)
		b.transform = $Muzzle.global_transform

func _on_baron_area_area_entered(area):
	"""Ivokes after hit"""
	$BaronHit.play()
	area.get_parent().queue_free()
	health -= Global.DAMAGE
	update_health_bar()

func update_health_bar():
	"""Updates players health"""
	$BaronHealthBar.value = health
	if health <= 0:
		$BaronCrash.play()
		fall_down()

func fall_down():
	"""Fall down animation when player is damaged."""
	var screen_bottom = get_viewport_rect().size.y
	while position.y < screen_bottom:
		position.y += Global.FALL_RATE
		var timer = get_tree().create_timer(Global.FALL_INTERVAL)
		await timer.timeout
		if position.y >= screen_bottom - Global.FALL_RATE:
			break
	get_tree().change_scene_to_file("res://menu.tscn")


func _physics_process(delta):
	"""Player game loop"""
	get_input()
	rotation += rotation_direction * rotation_speed * delta
	correct_rotation()
	shoot()
	move_and_slide()
