extends Control

onready var main_menu = $MainMenu
onready var server_ip_input = $MainMenu/ServerIP
onready var device_ip_label = $MainMenu/LocalIP

func _ready() -> void:
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	
	device_ip_label.text = Network.ip_address

func _player_connected(id: int) -> void:
	print_debug("Player " + str(id) + " has connected")

func _player_disconnected(id: int) -> void:
	print_debug("Player " + str(id) + " has disconnected")

func _on_create_server_pressed() -> void:
	main_menu.hide()
	Network.create_server()

func _on_join_server_pressed() -> void:
	if server_ip_input.text != "":
		main_menu.hide()
		Network.ip_address = server_ip_input.text
		Network.join_server()
