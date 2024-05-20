extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	Events.connect("new_speed_amount", update_speed)
	Events.connect("new_turret_amount", update_turrets)
	Events.connect("new_bomb_amount", update_freeze)
	Events.connect("new_life_amount", update_lives)

	Events.connect("new_wave_number", update_wave)

	update_turrets("3")
	update_freeze("1")
	update_speed("0.5")
	update_lives("10")

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update_turrets(amount):
	$Panel/Turrets/Number.text = "[center]"+str(amount)+"[/center]"
	print("Turrets: "+str(amount))

func update_speed(amount):
	$Panel/Speed/Number.text = "[center]"+str(amount)+"[/center]"
	print("Speed: "+str(amount))

func update_freeze(amount):
	$Panel/Freeze/Number.text = "[center]"+str(amount)+"[/center]"
	print("Freeze Bombs: "+str(amount))

func update_lives(amount):
	$Panel/Lives/Number.text = "[center]"+str(amount)+"[/center]"
	print("Lives: "+str(amount))

func update_wave(amount):
	$Panel/WaveNumber.text = "[center]Wave Number: "+str(amount)+"[/center]"
	print("Wave Number: "+str(amount))
