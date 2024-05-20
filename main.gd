extends Node2D

@onready var gameover_label: Label = $"CanvasLayer/Gameover Label"
@onready var enemy_spawner_location: Marker2D = $EnemySpawnerLocation
@onready var next_wave_timer: Timer = $NextWaveTimer
@onready var wait_timer: Timer = $WaitTimer
@onready var defend_zone: Area2D = $DefendZone
const ENEMY_SPAWNER = preload("res://enemies/enemy_spawner.tscn")
const PLAYER = preload("res://player/player.tscn")
var num_spawners: int = 0
var wave_num: int = 0
var is_gameover: bool = false
var wave_in_progress: bool = false
var num_wave_enemies: int = 0
var enemies_spawning: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	next_wave_timer.timeout.connect(on_next_wave_timer_timeout)
	defend_zone.body_entered.connect(on_defend_zone_entered)
	Debug.write("Instructions", "arrow keys to move, space to place turret, Z and X to fire. C to freeze bomb. Don't let the enemies touch the red zone")
	Events.turret_added.connect(on_turret_added, CONNECT_DEFERRED)
	prepare_next_wave() # start waves
	Events.enemy_spawned.connect(on_enemy_spawned)
	Events.enemy_died.connect(on_enemy_died)
	Events.player_died.connect(on_player_died)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	Debug.write("Num enemies", num_wave_enemies)
	if is_instance_valid(Global.player):
		Debug.write("Player health", Global.player.get_health())
		Debug.write("Available turrets", Global.player.available_turrets)
	else:
		Debug.write("Player health", "dead")

	if !next_wave_timer.is_stopped():
		Debug.write("Time to next wave", int(next_wave_timer.time_left))
	else:
		Debug.write("Time to next wave", int(wait_timer.time_left))

func setup_next_wave() -> void:
	if is_gameover:
		return

	wave_num += 1

	add_enemy_spawer()

	Events.emit_signal("new_wave_number", wave_num)

	Events.emit_signal("show_shop")

	match wave_num:
		1:
			Global.player.available_turrets = 2
			next_wave_timer.wait_time = 10
		2:
			Debug.items.erase("Instructions")
			Global.player.fire_rate /= 1.5
		3:
			next_wave_timer.wait_time = 15
			get_tree().call_group("turrets", "upgrade_turret")
		4:
			Global.player.fire_rate /= 1.5
		5:
			get_tree().call_group("spawners", "double_spawn_rate")
			next_wave_timer.wait_time = 20
		6:
			Global.player.fire_rate /= 1.5
			get_tree().call_group("turrets", "upgrade_turret")
		8:
			get_tree().call_group("spawners", "double_spawn_rate")
			Global.player.fire_rate /= 1.5

	if wave_num % 1 == 0:
		# Increase the health every one wave.
		Events.emit_signal("level_up_health")

	Debug.write("Wave", wave_num)
	if wave_num == 10:
		Debug.write("Wave", "FINAL WAVE")
	elif wave_num > 10:
		Debug.write("Wave", "ENDLESS")

# This function is called when all enemies in the wave have died
func prepare_next_wave() -> void:
	if wave_in_progress:
		wave_in_progress = false
		Events.wave_ended.emit()
	get_tree().call_group("turrets", "pause")

	# Give player some time to prepare for the next wave
	setup_next_wave()
	wait_timer.start(3)
	await wait_timer.timeout
	if wave_num <= 10:
		# if > 10, endless mode
		next_wave_timer.start()

	get_tree().call_group("spawners", "resume")
	get_tree().call_group("turrets", "resume")
	wave_in_progress = true
	enemies_spawning = true

# This function is called when the wave timer ends, and stops new enemies from spawning
func on_next_wave_timer_timeout() -> void:
	# Stop all spawners
	get_tree().call_group("spawners", "pause")
	enemies_spawning = false
	if num_wave_enemies == 0:
		prepare_next_wave()


func add_enemy_spawer() -> void:
	# create another enemy spawner
	var new_spawner = ENEMY_SPAWNER.instantiate()
	new_spawner.global_position = enemy_spawner_location.global_position
	add_child(new_spawner)
	new_spawner.pause()
	num_spawners += 1

func on_turret_added(turret: Node2D):
	if !wave_in_progress:
		turret.pause()

func on_defend_zone_entered(entered_node: Node2D) -> void:
	gameover()

func gameover() -> void:
	is_gameover = true
	if is_instance_valid(Global.player):
		Global.player.die()
	gameover_label.visible = true

func on_enemy_spawned() -> void:
	num_wave_enemies += 1

func on_enemy_died() -> void:
	num_wave_enemies -= 1
	if !enemies_spawning and num_wave_enemies == 0:
		prepare_next_wave()

func on_player_died() -> void:
	gameover()
