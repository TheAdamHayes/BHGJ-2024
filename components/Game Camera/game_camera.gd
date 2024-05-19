extends Camera2D

@export var camera_subject: Node2D


func _ready() -> void:
	if is_instance_valid(camera_subject):
		global_position = camera_subject.global_position


func _process(delta: float) -> void:
	# move camera towards player. If player dies, maintain camera position
	if is_instance_valid(camera_subject):
		global_position = camera_subject.global_position


# Sets the camera to follow a given subject.
func set_subject(subject: Node2D):
	camera_subject = subject
