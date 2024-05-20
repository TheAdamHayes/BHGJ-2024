extends Node2D

@onready var upgrade_timer: Timer = $UpgradeTimer
@onready var attack_timer: Timer = $AttackTimer
const MAX_UPGRADE_VERSION: int = 4
const LINE_BULLET = preload("res://bullets/line_bullet.tscn")
var upgrade_version: int = 1
# Define the width and length of each rectangle (adjust for size)
var width: int = 4
var length: int = 10
var radius: int = 4  # radius of circle body
var paused: bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play()
	add_to_group("turrets")
	# upgrade_timer.timeout.connect(upgrade_turret)
	attack_timer.timeout.connect(on_attack_timer_timeout)
	Events.turret_added.emit(self)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	queue_redraw()

func pause() -> void:
	upgrade_timer.paused = true
	attack_timer.paused = true

func resume() -> void:
	upgrade_timer.paused = false
	attack_timer.paused = false


func set_upgrade_version(ver: int):
	upgrade_version = ver


func fire() -> void:
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
			angles = [base_angle - spread_angle, base_angle, base_angle + spread_angle]
			bullet_damage = 4
		4:
			# shoot in a circle
			var num_bullets = 8
			bullet_speed = 150

			var timer = Timer.new()
			timer.wait_time = 0.1
			timer.one_shot = true
			add_child(timer)

			for i in range(num_bullets):
				var bullet = LINE_BULLET.instantiate()
				bullet.global_position = global_position
				bullet.speed = bullet_speed
				var shoot_direction: Vector2 = Vector2.UP.rotated(TAU * i / num_bullets)
				bullet.look_at(to_global(shoot_direction))
				get_parent().add_child(bullet)

				# Start the timer and wait for it to timeout
				timer.start()
				await timer.timeoutY

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
