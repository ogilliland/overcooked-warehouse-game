extends Control

onready var start_button: Button = $StartGame

func show_lobby() -> void:
	visible = true
	if Network.is_host:
		start_button.visible = true
	else:
		start_button.visible = false


func _on_start_game_pressed():
	visible = false
	Network.game.start()
