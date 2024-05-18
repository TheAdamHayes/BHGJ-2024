extends Node

var score: int
var shop

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.connect("shop_button_pressed", process_shop)
	Events.connect("show_shop", show_shop)
	Events.connect("hide_shop", hide_shop)
	# Hide at start of game
	self.visible = false

func show_shop():
	# Put SFX here on shop open
	print("Show Shop!")
	self.visible = true
	get_tree().paused = true

func process_shop(upgrade):
	print("Processing shop...")
	pull_score()

	if score < 500:
		hide_shop()
		return

	match upgrade:
		"1":
			Events.emit_signal("turret_upgrade")
			print("+1 turret!")
		"2":
			Events.emit_signal("freeze_bomb_upgrade")
			print("+1 Freeze Bomb!")
		"3":
			Events.emit_signal("speed_upgrade")
			print("+100 speed!")

	Events.emit_signal("update_score", 500, "subtract")
	hide_shop()


func hide_shop():
	print("Hide shop!")
	get_tree().paused = false
	self.visible = false

func pull_score():
	score = $"../../GameStats/Score".get_score()
	print("Score is currently: "+str(score))

