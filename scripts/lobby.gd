extends Control

onready var start_button: Control = $StartGame

onready var player1 = $HBoxContainer/LobbyPlayer1
onready var player2 = $HBoxContainer/LobbyPlayer2
onready var player3 = $HBoxContainer/LobbyPlayer3
onready var player4 = $HBoxContainer/LobbyPlayer4
onready var players = [player1, player2, player3, player4]


func _ready():
	Network.lobby = self
	get_tree().connect("network_peer_connected", self, "_player_connected")


func _player_connected(id: int):
	yield(get_tree().create_timer(0.5), "timeout")
	render_players()


func render_players():
	var i = 0
	for key in Players.players:
#		print("Player " + str(key))
		players[i].get_node("PlayerName").text = Players.players[key]
		i += 1
	print_debug("New player joined")
	for j in range(4):
		players[j].refresh()
#	print_debug(Players.players)


func show_lobby() -> void:
	visible = true
	if Network.is_host:
		start_button.visible = true
	else:
		start_button.visible = false


func _on_start_game_pressed():
	rpc("_start_match")

sync func _start_match() -> void:
	visible = false
	get_node("../GameViewport").visible = true
	Network.game.start()
