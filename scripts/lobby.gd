extends Control

onready var start_button: Control = $StartGame

onready var player1 = $HBoxContainer/LobbyPlayer1/PlayerName
onready var player2 = $HBoxContainer/LobbyPlayer2/PlayerName
onready var player3 = $HBoxContainer/LobbyPlayer3/PlayerName
onready var player4 = $HBoxContainer/LobbyPlayer4/PlayerName
onready var players = [player1, player2, player3, player4]


func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected")


func _player_connected(id: int):
	yield(get_tree().create_timer(0.5), "timeout")
	render_players()


func render_players():
	var i = 0
	for key in Players.players:
		print("Player " + str(key))
		players[i].text = Players.players[key]
		i += 1
	print_debug(Players.players)


func show_lobby() -> void:
	visible = true
	if Network.is_host:
		start_button.visible = true
	else:
		start_button.visible = false
	render_players()


func _on_start_game_pressed():
	visible = false
	get_node("../GameViewport").visible = true
	Network.game.start()
