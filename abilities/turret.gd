extends Node2D

@onready var upgrade_timer: Timer = $UpgradeTimer
@onready var attack_timer: Timer = $AttackTimer
const MAX_UPGRADE_VERSION: int = 3
const LINE_BULLET = preload("res://bullets/line_bullet.tscn")
var upgrade_version: int = 1
# Define the width and length of each rectangle (adjust for size)
var width: int = 4
var length: int = 10
var radius: int = 4  # radius of circle body
var paused: bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("turrets")
	upgrade_timer.timeout.connect(upgrade_turret)
	attack_timer.timeout.connect(on_attack_timer_timeout)
	Events.turret_added.emit(self)
	


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

func pause() -> void:
	upgrade_timer.paused = true
	attack_timer.paused = true

func resume() -> void:
	upgrade_timer.paused = false
	attack_timer.paused = false


func set_upgrade_version(ver: int):
	upgrade_version = ver


func fire():
	var bullet_speed: int = 60
	var angles: Array[float] = []
	var bullet_damage: int = 2
	match upgrade_version:
		1:
			# shoot upwards
			angles = [-90]
		2:
			# shoot in 4 directions
			bullet_speed = 100
			angles = [0, 90, 180, 270]
			bullet_damage = 3
		3:
			# shoot 3 upwards
			bullet_speed = 150
			var base_angle: int = 270
			var spread_angle: int = 25
			angles = [base_angle-spread_angle, base_angle, base_angle+spread_angle]
			bullet_damage = 4
		"unused":
			# shoot in a circle
			var num_bullets = 8
			bullet_speed = 150
			for i in num_bullets:
				var bullet = LINE_BULLET.instantiate()
				bullet.global_position = global_position
				bullet.speed = bullet_speed
				var shoot_direction: Vector2 = Vector2.UP.rotated(TAU * i / num_bullets)
				bullet.look_at(to_global(shoot_direction))
				get_parent().add_child(bullet)

	for angle in angles:
		var bullet: Node2D = LINE_BULLET.instantiate()
		bullet.global_position = global_position
		bullet.speed = bullet_speed
		bullet.rotate(deg_to_rad(angle))
		bullet.damage = bullet_damage
		get_tree().root.add_child(bullet)


func upgrade_turret():
	if upgrade_version >= MAX_UPGRADE_VERSION:
		return
	set_upgrade_version(upgrade_version + 1)
	match upgrade_version:
		2:
			# double attack speed
			attack_timer.wait_time /= 2
		3:
			# double attack speed
			attack_timer.wait_time /= 2

func on_attack_timer_timeout():
	fire()
