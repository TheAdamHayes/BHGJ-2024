extends CharacterBody2D
@onready var health_component = $HealthComponent
@onready var hitbox = $Hitbox
var speed = 20
var contact_damage: int = 2

@export var points: int = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	velocity = Vector2.ZERO
	health_component.health_changed.connect(on_health_changed)
	hitbox.body_entered.connect(on_hitbox_body_entered)


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
	Events.emit_signal("update_score", 10, "add")
	queue_free()


func on_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(contact_damage)
