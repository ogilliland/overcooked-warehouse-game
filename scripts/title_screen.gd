extends Control

onready var main_menu = $MainMenu
onready var server_ip_input = $MainMenu/ServerIP
onready var device_ip_label = $MainMenu/LocalIP
onready var game = $ViewportContainer/Viewport/Game
onready var round_timer = $ViewportContainer/HUD/CenterContainer/Control/RoundTimerLabel


func _ready() -> void:
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	get_tree().connect("connected_to_server", self, "_server_connected")

	device_ip_label.text = Network.ip_address


func _player_connected(id: int) -> void:
	print_debug("Player " + str(id) + " has connected")

	# Instance other players when a new client joins
	game.instance_player(id)


func _player_disconnected(id: int) -> void:
	print_debug("Player " + str(id) + " has disconnected")

	# Delete player when they disconnect
	if game.has_node(str(id)):
		game.get_node(str(id)).queue_free()


# Instance a player's own avatar when they join a server
func _server_connected() -> void:
	yield(get_tree().create_timer(0.1), "timeout")
	game.instance_player(get_tree().get_network_unique_id())


func _on_create_server_pressed() -> void:
	main_menu.hide()
	Network.create_server()
	round_timer.start()


func _on_join_server_pressed() -> void:
	if server_ip_input.text != "":
		main_menu.hide()
		Network.ip_address = server_ip_input.text
		Network.join_server()
