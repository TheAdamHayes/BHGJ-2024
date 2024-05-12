extends Node2D

@onready var next_wave_timer: Timer = $NextWaveTimer
@onready var wait_timer: Timer = $WaitTimer
@onready var defend_zone: Area2D = $DefendZone
const ENEMY_SPAWNER = preload("res://enemies/enemy_spawner.tscn")
const PLAYER = preload("res://player/player.tscn")
var num_spawners: int = 0
var wave_num: int = 0
var is_gameover: bool = false
var wave_in_progress: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	next_wave_timer.timeout.connect(on_next_wave_timer_timeout)
	defend_zone.body_entered.connect(on_defend_zone_entered)
	Debug.write("Instructions", "arrow keys to move, space to place turret, Z and X to fire. Don't let the enemies touch the red zone")
	Events.turret_added.connect(on_turret_added, CONNECT_DEFERRED)
	on_next_wave_timer_timeout.call_deferred() # start waves

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
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
	if !is_instance_valid(Global.player):
		# revive player if we haven't game overed
		add_child(PLAYER.instantiate())

	wave_num += 1
	match wave_num:
		1:
			add_enemy_spawer()
			Global.player.available_turrets += 3
			next_wave_timer.wait_time = 10
		2:
			Debug.items.erase("Instructions")
			add_enemy_spawer()
			Global.player.available_turrets += 1
			Global.player.fire_rate /= 1.5
		3:
			add_enemy_spawer()
			Global.player.available_turrets += 1
			next_wave_timer.wait_time = 15
		4:
			add_enemy_spawer()
			add_enemy_spawer()
			Global.player.available_turrets += 1
			Global.player.fire_rate /= 1.5
		5:
			add_enemy_spawer()
			add_enemy_spawer()
			get_tree().call_group("spawners", "double_spawn_rate")
			Global.player.available_turrets += 1
			next_wave_timer.wait_time = 20
		6:
			add_enemy_spawer()
			add_enemy_spawer()
			Global.player.available_turrets += 1
			Global.player.fire_rate /= 1.5
		7:
			add_enemy_spawer()
			add_enemy_spawer()
			Global.player.available_turrets += 1
		8:
			add_enemy_spawer()
			add_enemy_spawer()
			get_tree().call_group("spawners", "double_spawn_rate")
			Global.player.available_turrets += 1
		9:
			add_enemy_spawer()
			add_enemy_spawer()
			add_enemy_spawer()
		10:
			add_enemy_spawer()
			add_enemy_spawer()
			add_enemy_spawer()
			Global.player.fire_rate /= 1.5
	Debug.write("Wave", wave_num)
	if wave_num == 10:
		Debug.write("Wave", "FINAL WAVE")
	elif wave_num > 10:
		Debug.write("Wave", "ENDLESS")

func on_next_wave_timer_timeout() -> void:
	# Stop all spawners and turrets, and kill all enemies
	wave_in_progress = false
	get_tree().call_group("enemies", "queue_free")
	get_tree().call_group("spawners", "pause")
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

func add_enemy_spawer() -> void:
	# create another enemy spawner
	var new_spawner = ENEMY_SPAWNER.instantiate()
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
	Debug.write("GAMEOVER", "Press Shift-R to restart")