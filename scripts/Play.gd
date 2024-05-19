extends Button

# Preload the sparkle texture
var sparkle_texture = preload("res://assets/art/ui-small-sparkle.png")

# Number of sparkles to instantiate
const NUM_SPARKLES = 4

# Load the main scene
var main_scene = preload("res://main.tscn")

# Original color of the button
var original_modulate: Color

# Called when the node is ready
func _ready():
	# Connect the signals
	connect("mouse_entered", Callable(self, "_on_mouse_entered"))
	connect("mouse_exited", Callable(self, "_on_mouse_exited"))
	connect("button_down", Callable(self, "_on_button_down"))

	# Store the original color of the button
	original_modulate = modulate

	# Create the reveal overlay
	create_reveal_overlay()

# Called when the button is pressed
func _on_button_down():
	var mouse_position = get_viewport().get_mouse_position()
	print("Mouse Position: ", mouse_position)

	for i in range(NUM_SPARKLES):
		# Create a new sparkle
		var sparkle = Sprite2D.new()
		sparkle.texture = sparkle_texture
		get_tree().root.add_child(sparkle)  # Add the sparkle to the root node
		sparkle.global_position = mouse_position  # Use global_position for correct placement
		print("Sparkle Position: ", sparkle.global_position)

		# Fling the sparkle in a random direction
		var direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
		var speed = randf_range(100, 200)
		var fling_vector = direction * speed

		# Create the tween
		var tween = create_tween()

		# Animate the sparkle fling
		tween.tween_property(sparkle, "position", sparkle.position + fling_vector, 0.5)

		# Animate the fade out with a delay
		var fade_tweener = tween.tween_property(sparkle, "modulate", Color(1, 1, 1, 0), 0.5)
		fade_tweener.set_delay(0.5)

		# Connect the tween finished signal to free the sparkle
		tween.finished.connect(Callable(self, "_on_tween_finished").bind(sparkle))

	# Change the scene to main.tscn after a short delay to allow sparkles to show
	await get_tree().create_timer(0.6).timeout
	get_tree().change_scene_to_file("res://main.tscn")

func _on_tween_finished(sparkle):
	sparkle.queue_free()

# Called when the mouse enters the button area
func _on_mouse_entered():
	# Tint the button a darker color
	modulate = original_modulate.darkened(0.2)

# Called when the mouse exits the button area
func _on_mouse_exited():
	# Reset the button color to the original
	modulate = original_modulate

func create_reveal_overlay():
	# Create a ColorRect node for the black overlay
	var overlay = ColorRect.new()
	overlay.color = Color.BLACK
	overlay.size = get_viewport_rect().size
	overlay.position = Vector2(get_viewport_rect().size.x, 0)  # Start off-screen to the right
	get_tree().root.add_child(overlay)

	# Create the tween
	var tween = create_tween()

	# Animate the overlay moving from right to left
	tween.tween_property(overlay, "position", Vector2(0, 0), 2.0)

	# Connect the finished signal to remove the overlay after animation
	tween.finished.connect(Callable(self, "_on_reveal_overlay_finished").bind(overlay))

func _on_reveal_overlay_finished(overlay):
	overlay.queue_free()


# Random float between min and max
func randf_range(min, max):
	return randf() * (max - min) + min
