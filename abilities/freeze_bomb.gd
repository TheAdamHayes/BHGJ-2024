extends Area2D
const FREEZE_BOMB_EXPLOSION = preload("res://abilities/freeze_bomb_explosion.tscn")

var damage: int = 1
var speed: int = 0

@onready var life_timer: Timer = $LifeTimer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_entered.connect(on_bomb_hit)
	body_entered.connect(on_bomb_hit)
	life_timer.timeout.connect(queue_free)
	Events.wave_ended.connect(queue_free)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position += transform.x * speed * delta

func _draw():
	# Horizontal rectangle
	draw_circle(Vector2.ZERO, 10, Color.LIGHT_BLUE)

func on_bomb_hit(collider: Node2D):
	if collider.has_method("take_damage"):
		var damage_source: DamageSource = DamageSource.new()
		damage_source.damage = damage
		collider.take_damage(damage_source)
	explode.call_deferred()

func explode() -> void:
	var explosion: Area2D = FREEZE_BOMB_EXPLOSION.instantiate()
	explosion.global_position = global_position
	get_parent().add_child(explosion)
	queue_free()