extends Node

# Whenever you want to add a global signal to the game, add it here with its paras

signal update_score(amount, function)
signal score_changed(new_score)
signal turret_added(turret: Node2D)

signal freezeBombStatus(status)

signal shop_button_pressed(button)

signal turret_upgrade()
signal freeze_bomb_upgrade()
signal speed_upgrade()

signal show_shop()
signal hide_shop()
signal wave_ended

signal level_up_health()

signal new_bomb_amount(amount)
signal new_speed_amount(amount)
signal new_turret_amount(amount)

signal new_life_amount(amount)
signal new_wave_number(number)

signal enemy_spawned
signal enemy_died
signal player_died