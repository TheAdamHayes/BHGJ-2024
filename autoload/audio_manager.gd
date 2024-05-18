extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	Events.connect("wave_ended", onWaveEnd)
	Events.connect("turret_added", onTurretAdd)

func onWaveEnd():
	FMODRuntime.play_one_shot_path("event:/SFX/Environment/WaveComplete")

func onTurretAdd():
	FMODRuntime.play_one_shot_path("event:/SFX/Environment/TurretAdded")
