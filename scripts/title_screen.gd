extends Control

onready var main_menu = $MainMenu
# TO DO - update these paths to IP addresses
onready var server_ip_input = $MainMenu/NewGame/ServerIP
onready var device_ip_label = $Lobby/LocalIP
onready var player_name_input = $MainMenu/PlayerName
onready var game = $GameViewport/Viewport/Game
onready var lobby = $Lobby

func _resize() -> void:
	var size = get_viewport().size
	var scale = size.x / 1024 - 0.5
	scale = clamp(scale, 0.5, 4.0)
	var nodes_to_resize = [
		$GameViewport/HUD,
		$Lobby,
		$MainMenu
	]
	for node in nodes_to_resize:
		node.anchor_right = 1.0/scale
		node.anchor_bottom = 1.0/scale
		node.rect_scale = Vector2(scale, scale)

func _ready() -> void:
	get_tree().get_root().connect("size_changed", self, "_resize")
	_resize()
	
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	get_tree().connect("connected_to_server", self, "_server_connected")
	
	device_ip_label.text = Network.ip_address


func _player_connected(id: int) -> void:
	print_debug("Player " + str(id) + " has connected")
	print("HELLO")

	# Instance other players when a new client joins
	game.instance_player(id)
	# Keep a map with the names
	rpc_id(id, "register_player", Players.myName)


func _player_disconnected(id: int) -> void:
	print_debug("Player " + str(id) + " has disconnected")

	Players.players.erase(id)

	# Delete player when they disconnect
	if game.has_node(str(id)):
		game.get_node(str(id)).queue_free()


# Instance a player's own avatar when they join a server
func _server_connected() -> void:
	yield(get_tree().create_timer(0.1), "timeout")
	game.instance_player(get_tree().get_network_unique_id())


func _on_create_server_pressed() -> void:
	set_player_name()
	Network.is_host = true
	main_menu.hide()
	lobby.show_lobby()
	Network.create_server()


func _on_join_server_pressed() -> void:
	set_player_name()
	if server_ip_input.text != "":
		Network.is_host = false
		main_menu.hide()
		lobby.show_lobby()
		Network.ip_address = server_ip_input.text
		Network.join_server()


remote func register_player(player_name: String):
	# Get the id of the RPC sender.
	var id = get_tree().get_rpc_sender_id()
	# Store the info
	Players.players[id] = player_name


func set_player_name() -> void:
	var player_name = player_name_input.text
	if player_name == "":
		player_name = "Player" + str(randi() % 1000)
	Players.myName = player_name
