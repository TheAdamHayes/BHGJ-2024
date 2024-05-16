extends CharacterBody2D

enum State {
	Moving,
	Frozen,
}

@onready var health_component = $HealthComponent
@onready var hitbox = $Hitbox
@onready var freeze_timer: Timer = $FreezeTimer
var speed = 20
var contact_damage: int = 2
var state: State = State.Moving

@export var points: int = 10


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("enemies")
	velocity = Vector2.ZERO
	health_component.health_changed.connect(on_health_changed)
	hitbox.body_entered.connect(on_hitbox_body_entered)
	freeze_timer.timeout.connect(on_freeze_timer_timeout)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	queue_redraw()
	# Only move if not frozen
	match state:
		State.Moving:
			var direction = Vector2.DOWN
			velocity = direction * speed
			move_and_slide()
		State.Frozen:
			return


func _draw() -> void:
	# If frozen, draw as a blue circle
	match state:
		State.Moving:
			draw_circle(Vector2.ZERO, 8, Color.RED)
		State.Frozen:
			draw_circle(Vector2.ZERO, 8, Color.BLUE)


func take_damage(damage_source: DamageSource) -> void:
	health_component.reduce_health(damage_source.damage)
	if damage_source.status == DamageSource.StatusEffect.Freeze:
		state = State.Frozen
		freeze_timer.start()

func on_health_changed(new_health_amount: int) -> void:
	if new_health_amount == 0:
		die()


func die() -> void:
	Events.emit_signal("update_score", 10, "add")
	queue_free()


func on_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(contact_damage)

func on_freeze_timer_timeout() -> void:
	if state == State.Frozen:
		state = State.Moving