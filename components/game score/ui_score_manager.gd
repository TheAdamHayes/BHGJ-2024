extends Node

func _ready():
	Events.connect("score_changed", update_score)

func update_score(new_score):
	$RichTextLabel.text = "[right]"+str(new_score)+"[/right]"
