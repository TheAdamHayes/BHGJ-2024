extends CharacterBody2D
@onready var health_component = $HealthComponent

var speed = 60


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	velocity = Vector2.ZERO
	health_component.health_changed.connect(on_health_changed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	queue_redraw()
	if is_instance_valid(Global.player):
		var direction = global_position.direction_to(Global.player.global_position)
		velocity = direction * speed
	move_and_slide()


func _draw() -> void:
	draw_circle(Vector2.ZERO, 8, Color.RED)


func take_damage(damage: int) -> void:
	health_component.reduce_health(damage)


func on_health_changed(new_health_amount: int) -> void:
	if new_health_amount == 0:
		die()


func die() -> void:
	queue_free()
