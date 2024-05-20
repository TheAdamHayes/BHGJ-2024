extends Control

var actual_score: int
var visual_score: int = 0

func _ready():
	Events.connect("game_over", show_gameover)
	Events.connect("game_over_score", game_over_score)

# Called when the node enters the scene tree for the first time.
func show_gameover():
	self.visible = true
	$AnimationPlayer.play("enter")
	await $AnimationPlayer.animation_finished
	show_score()
	get_tree().paused = true

func hide_gameover():
	self.visible = false
	get_tree().paused = false

func game_over_score(score):
	actual_score = score

func get_score():
	Events.emit_signal("get_score")

func show_score():
	get_score()
	visual_score = 0

	while visual_score != actual_score:
		print("Visual Score:" +str(visual_score))
		print("Score is:" +str(actual_score))
		$Score.text = str(visual_score)
		visual_score += 50

		$score_timer.start()
		await $score_timer.timeout

	$Score.text = str(visual_score)



