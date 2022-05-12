extends Control

onready var menu_buttons = $MenuButtons
onready var new_game = $NewGame

func _on_new_game_pressed():
	print_debug("New game")
	menu_buttons.visible = false
	new_game.visible = true

func _on_exit_pressed():
	print_debug("Exit")
	get_tree().quit()
