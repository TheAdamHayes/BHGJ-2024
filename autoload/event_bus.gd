extends Node

# Whenever you want to add a global signal to the game, add it here with its paras

signal update_score(amount, function)
signal score_changed(new_score)
signal turret_added(turret: Node2D)
signal wave_ended
