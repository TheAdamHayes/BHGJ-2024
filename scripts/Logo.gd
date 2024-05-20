extends TextureRect

@onready var tween = $Tween

func _ready():
	# Set the initial state
	modulate.a = 0.0
	self.position += Vector2(0, 20)

	# Start the tween
	tween.tween_property(self, "modulate:a", 1.0, 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.tween_property(self, "rect_position", self.position - Vector2(0, 20), 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
