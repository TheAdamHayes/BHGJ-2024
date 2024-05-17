extends Area2D

var radius: int = 40
var damage: int = 2
@onready var life_timer: Timer = $LifeTimer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_entered.connect(on_explosion_hit)
	body_entered.connect(on_explosion_hit)
	life_timer.timeout.connect(queue_free)
	Events.wave_ended.connect(queue_free)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _draw():
	draw_circle(Vector2.ZERO, radius, Color.LIGHT_BLUE)

func on_explosion_hit(collider: Node2D):
	if collider.has_method("take_damage"):
		var damage_source: DamageSource = DamageSource.new()
		damage_source.damage = damage
		damage_source.status = DamageSource.StatusEffect.Freeze
		collider.take_damage(damage_source)
