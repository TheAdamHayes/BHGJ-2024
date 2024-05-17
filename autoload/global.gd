extends Node

# Type: optional. Must always check for is_instance_valid(Global.player)
# avoid modifying state of player (writes)
var player: CharacterBody2D = null
var wave_in_progress: bool = false
