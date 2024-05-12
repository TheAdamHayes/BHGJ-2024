extends Node

var score: int = 0
signal score_changed

func _ready():
	# Grab it from the events bus and connect it to the method.
	Events.connect("update_score", change_score)


func get_score():
	return score

func change_score(amount, function):
	match function:
		"add": score += amount
		"subtract": score -= amount
		"multiply": score *= amount
		"divide": score /= amount

	# Pass it to the Events Buss, which the UI picks up from
	Events.emit_signal("score_changed", score)

