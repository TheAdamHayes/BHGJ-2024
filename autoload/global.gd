extends Node

# Type: optional. Must always check for is_instance_valid(Global.player)
# avoid modifying state of player (writes)
var player: CharacterBody2D = null


# Quit any scene using esc while we're developing
func _input(_event):
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()
