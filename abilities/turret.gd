extends Node2D

@onready var upgrade_timer: Timer = $UpgradeTimer
@onready var attack_timer: Timer = $AttackTimer
const LINE_BULLET = preload("res://bullets/line_bullet.tscn")
var upgrade_version: int = 2
# Define the width and length of each rectangle (adjust for size)
var width: int = 4
var length: int = 10
var radius: int = 4  # radius of circle body


# Called when the node enters the scene tree for the first time.
func _ready():
	upgrade_timer.timeout.connect(on_upgrade_timer_timeout)
	attack_timer.timeout.connect(on_attack_timer_timeout)
	# fire.call_deferred() # fire once as soon as physics processing starts


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	queue_redraw()


func _draw():
	match upgrade_version:
		1:
			# Draw vertical rectangle
			draw_rect(Rect2(-width / 2.0, -length / 2.0, width, length), Color.WHITE)
		2:
			# Draw a cross
			# Vertical rectangle
			draw_rect(Rect2(-width / 2.0, -length / 2.0, width, length), Color.WHITE)
			# Horizontal rectangle
			draw_rect(Rect2(-length / 2.0, -width / 2.0, length, width), Color.WHITE)
		3:
			# draw cross with a circle
			draw_rect(Rect2(-width / 2.0, -length / 2.0, width, length), Color.WHITE)
			draw_rect(Rect2(-length / 2.0, -width / 2.0, length, width), Color.WHITE)
			draw_circle(Vector2.ZERO, radius, Color.WHITE)


func set_upgrade_version(ver: int):
	upgrade_version = ver


func fire():
	# upgrade version 1: shoot 2 bullets with speed 100
	var num_bullets: int = 2
	var bullet_speed: int = 60
	match upgrade_version:
		2:
			# shoot in 4 directions
			num_bullets = 4
			bullet_speed = 100
		3:
			# shoot in a circle
			num_bullets = 8
			bullet_speed = 150

	for i in num_bullets:
		var bullet = LINE_BULLET.instantiate()
		bullet.global_position = global_position
		bullet.speed = bullet_speed
		var shoot_direction: Vector2 = Vector2.UP.rotated(TAU * i / num_bullets)
		bullet.look_at(to_global(shoot_direction))
		get_parent().add_child(bullet)


func on_upgrade_timer_timeout():
	if upgrade_version < 3:
		set_upgrade_version(upgrade_version + 1)
	# elif upgrade_version == 3:
	# destroy turret
	# queue_free()


func on_attack_timer_timeout():
	fire()
