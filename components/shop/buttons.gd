extends Node

func _on_button_down():
	print("Pressed: "+str(self.name))
	Events.emit_signal("shop_button_pressed", self.name)
