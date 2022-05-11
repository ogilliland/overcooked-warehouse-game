extends Spatial

var Player = preload("res://scenes/player.tscn")

func _ready() -> void:
	Network.game = self

func instance_player(id: int) -> void:
	var player_instance = Player.instance()
	player_instance.name = str(id)
	player_instance.set_network_master(id)
	add_child(player_instance)
	# Randomize player position for testing
	# TO DO - replace this with actual spawn locations defined in the map
	player_instance.global_transform.origin = Vector3(
		rand_range(-10, 10),
		0,
		rand_range(-10, 10)
	)
