extends Node

var freezeBombInstance: EventInstance


# Called when the node enters the scene tree for the first time.
func _ready():
	Events.connect("freezeBombStatus", setFreezeBombStatus)
	Events.connect("wave_ended", onWaveEnd)
	Events.connect("turret_added", onTurretAdd)
	
	freezeBombInstance = FMODRuntime.create_instance_path("event:/TestEvent")

func onWaveEnd():
	FMODRuntime.play_one_shot_path("event:/SFX/Environment/WaveComplete")

func onTurretAdd():
	FMODRuntime.play_one_shot_path("event:/SFX/Environment/TurretAdded")

func setFreezeBombStatus(status):
	if (status == "traveling"):
		freezeBombInstance.start()
	elif (status == "hit"):
		freezeBombInstance.set_parameter_by_name_with_label("freezeBombStatus", "hit", false)
	print_debug(status)
