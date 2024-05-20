extends AnimatedSprite2D

var direction: Vector2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	direction = get_input_direction()

	if direction[0] == 0:
		# Neutral
		self.frame = 0
	elif direction[0] == 1:
		# Right
		self.frame = 2
	elif direction[0] == -1:
		# Left
		self.frame = 1

func get_input_direction() -> Vector2:
	var x_movement: float = Input.get_action_strength("right") - Input.get_action_strength("left")
	var y_movement: float = Input.get_action_strength("down") - Input.get_action_strength("up")
	return Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down")).normalized()
