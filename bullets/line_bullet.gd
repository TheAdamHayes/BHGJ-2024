extends Node2D
@onready var hitbox: Area2D = $Hitbox
@onready var life_timer: Timer = $LifeTimer

# Define the width and length of bullet
var width: int = 3
var length: int = 7
var speed: int = 0
var damage: int = 2
var color: Color = Color.ORANGE


# Called when the node enters the scene tree for the first time.
func _ready():
	hitbox.area_entered.connect(on_bullet_hit)
	hitbox.body_entered.connect(on_bullet_hit)
	life_timer.timeout.connect(queue_free)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position += transform.x * speed * delta


func _draw():
	# Horizontal rectangle
	draw_rect(Rect2(-length / 2.0, -width / 2.0, length, width), color)

# Determines who this bullet will attack
func set_attack_type(type: String):
	hitbox.set_collision_mask(0)  # reset mask
	match type:
		"player":
			# attack players
			hitbox.set_collision_mask_value(1, true)
		"enemy":
			# attack enemies
			hitbox.set_collision_mask_value(2, true)
		"both":
			# attack both player and enemies
			hitbox.set_collision_mask_value(1, true)
			hitbox.set_collision_mask_value(2, true)
		_:
			print("invalid bullet attac type")

func on_bullet_hit(collider):
	if collider.has_method("take_damage"):
		var damage_source: DamageSource = DamageSource.new()
		damage_source.damage = damage
		collider.take_damage(damage_source)
	queue_free()
