extends Button

# Preload the sparkle texture
var sparkle_texture = preload("res://assets/art/ui-small-sparkle.png")

# Number of sparkles to instantiate
const NUM_SPARKLES = 4

# Load the main scene
var main_scene = preload("res://main.tscn")

var original_modulate: Color

# Called when the node is ready
func _ready():
	# Connect the signals
	connect("mouse_entered", Callable(self, "_on_mouse_entered"))
	connect("mouse_exited", Callable(self, "_on_mouse_exited"))

	# Store the original color of the button
	original_modulate = modulate

# # SPARKLES # #
func _on_button_down():

	for i in range(NUM_SPARKLES):
		# Create a new sparkle
		var sparkle = Sprite2D.new()
		sparkle.texture = sparkle_texture
		add_child(sparkle)

		# Set the initial position of the sparkle to the cursor's position
		sparkle.global_position = get_viewport().get_mouse_position()
		print(sparkle.position)

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
#	get_tree().quit()

func _on_tween_finished(sparkle):
	sparkle.queue_free()

# Random float between min and max
func randf_range(min, max):
	return randf() * (max - min) + min

# Called when the mouse enters the button area
func _on_mouse_entered():
	# Tint the button a darker color
	modulate = original_modulate.darkened(0.2)

# Called when the mouse exits the button area
func _on_mouse_exited():
	# Reset the button color to the original
	modulate = original_modulate
