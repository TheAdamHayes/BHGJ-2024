extends CanvasLayer

@onready var debug_label: Label = $DebugData

var items: Dictionary = {}  # String: Variant
var enabled: bool = true
var starting_time: int
var frame_count: int = 0


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("next_frame", true):
		frame_count += 1
		if get_tree().paused:
			get_tree().paused = false
		await get_tree().process_frame
		get_tree().paused = true
	if Engine.get_process_frames() % 3 == 0:
		# Run expensive logic only once every 2 process (render) frames here.
		if enabled:
			_set_debug_text()


# Toggle debug globally with the hotkey
func _input(event) -> void:
	if event.is_action_pressed("debug"):
		enabled = !enabled
		visible = enabled
	if event.is_action_pressed("reset"):
		get_tree().reload_current_scene()
	if event.is_action_pressed("pause_resume"):
		frame_count = 0
		get_tree().paused = not get_tree().paused


func _set_debug_text() -> void:
	var debug_text: String = "fps: " + str(Engine.get_frames_per_second())
	if get_tree().paused:
		debug_text = "frame: " + str(frame_count)
	for key in items:
		debug_text += "\n" + key + ":" + str(items[key])
	$DebugData.text = debug_text


# Example usage, write player position to screen overlay:
# Debug.write("player position", position)
func write(key: String, value: Variant) -> void:
	items[key] = value


# Example usage, call some_function(some_arg) and print how long it takes:
# Debug.time_call(some_function.bind(some_arg))
func time_call(some_function: Callable) -> Variant:
	var start_time = Time.get_ticks_msec()
	var ret = some_function.call()
	print(
		(
			"%s returned %s after %sms"
			% [some_function.get_method(), ret, Time.get_ticks_msec() - start_time]
		)
	)
	return ret
