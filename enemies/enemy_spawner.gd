extends Node2D

@onready var spawn_timer: Timer = $SpawnTimer
const BASIC_ENEMY = preload("res://enemies/basic_enemy.tscn")
const SPAWN_DISTANCE = 300


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_timer.timeout.connect(on_spawn_timer_timeout)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func on_spawn_timer_timeout() -> void:
	if !is_instance_valid(Global.player):
		return

	# spawn enemy SPAWN_DISTANCE units above player
	var enemy = BASIC_ENEMY.instantiate()
	var random_distance: Vector2 = (
		Vector2.RIGHT.rotated(randf_range(deg_to_rad(-145), deg_to_rad(-20))) * SPAWN_DISTANCE
	)
	enemy.global_position = Global.player.global_position + random_distance
	get_parent().add_child(enemy)
