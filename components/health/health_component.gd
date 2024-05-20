extends Node
class_name HealthComponent

signal health_changed(health: int)
@export var max_health: int = 0
@onready var health: int = max_health

func reduce_health(dmg: int) -> int:
	var current_hp: int = health
	health = max(health - dmg, 0)
	if current_hp != health:
		health_changed.emit(health)

	# return how much hp damaged
	return current_hp - health
