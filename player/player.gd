extends CharacterBody2D

const FREEZE_BOMB = preload("res://abilities/freeze_bomb.tscn")
const TURRET = preload("res://abilities/turret.tscn")
const LINE_BULLET = preload("res://bullets/line_bullet.tscn")

var speed = 100

var invincible: bool = false
var time_since_last_fire: float = 0.0
var fire_rate: float = 0.5  # Adjust this value to control the fire rate (in seconds)
var available_turrets: int = 0
var shop: bool = false

@onready var health_component = $HealthComponent
@onready var bomb_cooldown: Timer = $BombCooldown
# Called when the node enters the scene tree for the first time.
func _ready():
	Global.player = self
	health_component.health_changed.connect(on_health_changed)
	Events.connect("speed_upgrade", speed_upgrade)
	Events.connect("turret_upgrade", turret_upgrade)

func _input(_event):
	if Input.is_action_just_pressed("spacebar"):
		if available_turrets > 0:
			var turret = TURRET.instantiate()
			turret.global_position = global_position
			get_parent().add_child(turret)
			available_turrets -= 1
	if Input.is_action_just_pressed("bomb"):
		shoot_freeze_bomb()

	if Input.is_action_just_pressed("shop") and shop == false:
		print(str(shop))
		Events.emit_signal("show_shop")
		shop = !shop
		return
	elif Input.is_action_just_pressed("shop") and shop == true:
		Events.emit_signal("hide_shop")
		print(str(shop))
		shop = !shop
		return



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	queue_redraw()
	if Input.is_action_pressed("attack") and time_since_last_fire >= fire_rate:
		shoot_type1()
		time_since_last_fire = 0
	if Input.is_action_pressed("attack2") and time_since_last_fire >= fire_rate:
		shoot_type2()
		time_since_last_fire = 0
	time_since_last_fire += delta
	velocity = get_input_direction() * speed
	move_and_slide()
	stay_in_viewport()
	Debug.write("Freeze bomb cooldown", int(bomb_cooldown.time_left))

func shoot_type1() -> void:

	FMODRuntime.play_one_shot_path("event:/SFX/Player/SimpleShot")
	# shoot two bullets in a straight line 
	var bullet: Node2D = LINE_BULLET.instantiate()
	bullet.global_position = global_position - Vector2(5, 0)
	bullet.rotate(deg_to_rad(270))
	bullet.speed = 200
	bullet.damage = 2
	bullet.color = Color.YELLOW
	get_tree().root.add_child(bullet)
	bullet.set_attack_type("enemy")

	var bullet2: Node2D = LINE_BULLET.instantiate()
	bullet2.global_position = global_position + Vector2(5, 0)
	bullet2.rotate(deg_to_rad(270))
	bullet2.speed = 150
	bullet2.damage = 2
	bullet2.color = Color.YELLOW
	get_tree().root.add_child(bullet2)
	bullet2.set_attack_type("enemy")

func shoot_type2() -> void:
	FMODRuntime.play_one_shot_path("event:/SFX/Player/TripleShot")
	# shoot 3 bullets in a spread
	var base_angle: int = 270
	var spread_angle: int = 25
	var angles: Array[float] = [base_angle-spread_angle, base_angle, base_angle+spread_angle]
	for angle in angles:
		var bullet: Node2D = LINE_BULLET.instantiate()
		bullet.global_position = global_position
		bullet.speed = 100
		bullet.rotate(deg_to_rad(angle))
		bullet.damage = 2
		bullet.color = Color.YELLOW
		get_tree().root.add_child(bullet)
		bullet.set_attack_type("enemy")

func shoot_freeze_bomb() -> void:
	FMODRuntime.play_one_shot_path("event:/SFX/Player/FreezeBomb")
	if !bomb_cooldown.is_stopped():
		# bomb is on cooldown
		return
	var freeze_bomb = FREEZE_BOMB.instantiate()
	freeze_bomb.global_position = global_position
	freeze_bomb.speed = 100
	freeze_bomb.damage = 1
	freeze_bomb.rotate(deg_to_rad(270))
	get_parent().add_child(freeze_bomb)
	bomb_cooldown.start()


func get_input_direction() -> Vector2:
	var x_movement: float = Input.get_action_strength("right") - Input.get_action_strength("left")
	var y_movement: float = Input.get_action_strength("down") - Input.get_action_strength("up")
	return Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down")).normalized()

func _draw():
	draw_circle(Vector2.ZERO, 3, Color.HOT_PINK)


func take_damage(damage_source: DamageSource) -> void:
	if !invincible:
		health_component.reduce_health(damage_source.damage)
		activate_iframe_seconds(2)

# over the next duration seconds, be invincible and flicker visibility
func activate_iframe_seconds(duration: float) -> void:
	invincible = true
	var saved_collision_layer: int = collision_layer
	collision_layer = 0
	var flicker_interval: float = 0.15
	var tween: Tween = create_tween().set_loops()
	tween.tween_callback(set_visible.bind(false))
	tween.tween_interval(flicker_interval)
	tween.tween_callback(set_visible.bind(true))
	tween.tween_interval(flicker_interval)
	await get_tree().create_timer(duration).timeout
	tween.kill()
	set_visible(true)
	collision_layer = saved_collision_layer
	invincible = false

func on_health_changed(new_health_amount: int) -> void:
	if new_health_amount == 0:
		die()

func die() -> void:
	FMODRuntime.play_one_shot_path("events:/SFX/Environment/PlayerDeath")
	queue_free()

func get_health() -> int:
	FMODRuntime.play_one_shot_path("events:/SFX/Environment/PlayerHeal")
	return health_component.health

# Hacky way to keep player from leaving screen for fast prototype purposes only
# only works when the game is centered at 0,0
func stay_in_viewport():
	var viewport: Vector2 = get_viewport_rect().size
	position = position.clamp(
		Vector2(-viewport.x / 2, -viewport.y / 2), Vector2(viewport.x / 2, viewport.y / 2)
	)

func speed_upgrade():
	speed += 100

func turret_upgrade():
	available_turrets += 1
