extends CharacterBody2D

enum State {
	Moving,
	Frozen,
}

@onready var health_component = $HealthComponent
@onready var hitbox = $Hitbox
@onready var freeze_timer: Timer = $FreezeTimer

var contact_damage = DamageSource.new(2)
var state: State = State.Moving

@export var points: int = 500
@export var speed = 40


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Events.enemy_spawned.emit()
	Events.connect("level_up_health", level_up_health)

	# Freeze the enemy
	state = State.Frozen

	add_to_group("enemies")
	velocity = Vector2.ZERO
	health_component.health_changed.connect(on_health_changed)
	hitbox.body_entered.connect(on_hitbox_body_entered)
	freeze_timer.timeout.connect(on_freeze_timer_timeout)

	# Play the animation
	$AnimationPlayer.play("enter")
	await $AnimationPlayer.animation_finished

	# Let the guy move.
	state = State.Moving



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
			pass
		State.Frozen:
			pass


func take_damage(damage_source: DamageSource) -> void:
	health_component.reduce_health(damage_source.damage)
	if damage_source.status == DamageSource.StatusEffect.Freeze:
		state = State.Frozen
		freeze_timer.start()

func on_health_changed(new_health_amount: int) -> void:
	if new_health_amount == 0:
		die()


func die() -> void:
	FMODRuntime.play_one_shot_path("event:/SFX/Enemy/Death")
	Events.emit_signal("update_score", points, "add")
	Events.enemy_died.emit()
	queue_free()


func on_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(contact_damage)

func on_freeze_timer_timeout() -> void:
	if state == State.Frozen:
		state = State.Moving

func level_up_health() -> void:
	$HealthComponent.max_health += 1
