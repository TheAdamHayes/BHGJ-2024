extends Node2D

@onready var timer: Timer = $Timer
const ENEMY_SPAWNER = preload("res://enemies/enemy_spawner.tscn")
var num_spawners = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	timer.timeout.connect(on_timer_timeout)
	Debug.write("Instructions", " WASD to move, space to place turret")
	await get_tree().create_timer(10).timeout
	Debug.items.erase("Instructions")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_instance_valid(Global.player):
		Debug.write("Player health", Global.player.get_health())
	else:
		Debug.write("Player health", "dead")


func on_timer_timeout() -> void:
	# create another enemy spawner
	add_child(ENEMY_SPAWNER.instantiate())
	num_spawners += 1
