extends Node2D

@onready var spawn_timer: Timer = $SpawnTimer
const BASIC_ENEMY = preload("res://enemies/basic_enemy.tscn")
const SPAWN_AREA_LENGTH = 150 # ideally there would be a visual representation of this

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("spawners")
	spawn_timer.timeout.connect(on_spawn_timer_timeout)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func pause() -> void:
	spawn_timer.paused = true

func resume() -> void:
	spawn_timer.paused = false

func double_spawn_rate() -> void:
	set_spawn_period(spawn_timer.wait_time/2)

func set_spawn_period(time: float) -> void:
	spawn_timer.wait_time = time

func on_spawn_timer_timeout() -> void:
	if !is_instance_valid(Global.player):
		return

	# spawn enemies right above the screen
	var enemy = BASIC_ENEMY.instantiate()
	var spawn_point: Vector2 = global_position
	var viewport_size: Vector2 = get_viewport_rect().size
	# Set y coord to be in horizon line.
	# Set x coord to be random point within the screen
	# Spawner should be positioned at the top left of the spawn area
	spawn_point.y = position.y
	spawn_point.x = position.x + randi_range(0, SPAWN_AREA_LENGTH)
	enemy.global_position = spawn_point
	# spawn_point.x = randf_range(global_position.x - (viewport_size.x/2) + 10, global_position.x + (viewport_size.x/2) - 10)
	get_parent().add_child(enemy)
