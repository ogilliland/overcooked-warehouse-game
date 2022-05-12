extends Node

const DEFAULT_PORT: int = 28960
const MAX_CLIENTS: int = 4

var server: NetworkedMultiplayerENet
var client: NetworkedMultiplayerENet

var ip_address: String = ""
var is_host: bool = false

# Create placeholder reference to game scene which we populate on ready in the game script
# This is a bit hacky but it works for now ¯\_(ツ)_/¯
var game: Spatial

func _ready() -> void:
	for ip in IP.get_local_addresses():
		if ip.begins_with("192.168."):
			ip_address = ip
	
	get_tree().connect("connected_to_server", self, "_server_connected")
	get_tree().connect("server_disconnected", self, "_server_disconnected")

func _server_connected() -> void:
	print_debug("Connected to server!")

func _server_disconnected() -> void:
	print_debug("Disconnected from server!")

func create_server() -> void:
	server = NetworkedMultiplayerENet.new()
	server.create_server(DEFAULT_PORT, MAX_CLIENTS)
	get_tree().set_network_peer(server)
	
	# Use the reference to the game scene populated earlier
	# Instance a player for the server host on their own machine
	game.instance_player(get_tree().get_network_unique_id())

func join_server() -> void:
	client = NetworkedMultiplayerENet.new()
	client.create_client(ip_address, DEFAULT_PORT)
	get_tree().set_network_peer(client)
