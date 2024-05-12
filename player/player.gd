extends CharacterBody2D
@onready var health_component = $HealthComponent

const TURRET = preload("res://abilities/turret.tscn")
var speed = 100
var invincible: bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.player = self
	health_component.health_changed.connect(on_health_changed)


func _input(_event):
	if Input.is_action_just_pressed("left_click"):
		pass
	if Input.is_action_just_pressed("right_click"):
		pass
	if Input.is_action_just_pressed("spacebar"):
		var turret = TURRET.instantiate()
		turret.global_position = global_position
		get_parent().add_child(turret)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	queue_redraw()
	velocity = get_input_direction() * speed
	move_and_slide()
	stay_in_viewport()


func get_input_direction() -> Vector2:
	var x_movement: float = Input.get_action_strength("right") - Input.get_action_strength("left")
	var y_movement: float = Input.get_action_strength("down") - Input.get_action_strength("up")
	return Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down")).normalized()


func _draw():
	draw_circle(Vector2.ZERO, 3, Color.HOT_PINK)


func take_damage(damage: int) -> void:
	if !invincible:
		health_component.reduce_health(damage)
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
	queue_free()


func get_health() -> int:
	return health_component.health


# Hacky way to keep player from leaving screen for fast prototype purposes only
# only works when the game is centered at 0,0
func stay_in_viewport():
	var viewport: Vector2 = get_viewport_rect().size
	position = position.clamp(
		Vector2(-viewport.x / 2, -viewport.y / 2), Vector2(viewport.x / 2, viewport.y / 2)
	)
