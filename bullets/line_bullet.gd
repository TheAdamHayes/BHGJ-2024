extends Node2D
@onready var hitbox: Area2D = $Hitbox

# Define the width and length of bullet
var width: int = 3
var length: int = 7
var speed: int = 0
var damage = 2


# Called when the node enters the scene tree for the first time.
func _ready():
	hitbox.area_entered.connect(on_bullet_hit)
	hitbox.body_entered.connect(on_bullet_hit)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position += transform.x * speed * delta


func _draw():
	# Horizontal rectangle
	draw_rect(Rect2(-length / 2.0, -width / 2.0, length, width), Color.ORANGE)


func on_bullet_hit(collider):
	if collider.has_method("take_damage"):
		collider.take_damage(damage)
	queue_free()
