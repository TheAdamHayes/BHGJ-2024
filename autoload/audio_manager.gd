extends Node

var freezeBombInstance: EventInstance
var masterBus: Bus
var sfxBus: Bus
var musicBus: Bus

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.connect("freezeBombStatus", setFreezeBombStatus)
	Events.connect("wave_ended", onWaveEnd)
	Events.connect("turret_added", onTurretAdd)
	
	freezeBombInstance = FMODRuntime.create_instance_path("event:/TestEvent")
	
	masterBus = FMODStudioModule.get_studio_system().get_bus_by_id(FMODGuids.Busses.MASTER)
	sfxBus = FMODStudioModule.get_studio_system().get_bus_by_id(FMODGuids.Busses.MASTER_SFX)
	musicBus = FMODStudioModule.get_studio_system().get_bus_by_id(FMODGuids.Busses.MASTER_MUSIC)

func onWaveEnd():
	FMODRuntime.play_one_shot_path("event:/SFX/Environment/WaveComplete")

func onTurretAdd():
	FMODRuntime.play_one_shot_path("event:/SFX/Environment/TurretAdded")

func setFreezeBombStatus(status):
	print_debug(status)

func _process(delta):
	
	#Sets the volume levels for each bus, expand if needed. Vals between 0.0 amd 1.0, 0.5 is default
	masterBus.set_volume(0.5)
	sfxBus.set_volume(0.5)
	musicBus.set_volume(0.5)
