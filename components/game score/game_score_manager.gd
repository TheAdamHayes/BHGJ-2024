extends Node

var score: int = 0
signal score_changed

func _ready():
	# Grab it from the events bus and connect it to the method.
	Events.connect("update_score", change_score)
	Events.connect("get_score", event_gameover_score)


func event_gameover_score():
	Events.emit_signal("game_over_score", score)
	print("EVENT GAME OVER SCORE: "+str(score))

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

