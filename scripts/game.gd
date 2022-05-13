extends Spatial

var Player: PackedScene = preload("res://scenes/player.tscn")
var round_timer: Control

var players = []

func _ready() -> void:
	Network.game = self
	var hud = get_node("../../HUD")
	round_timer = hud.get_round_timer()
#	round_timer = get_node("../../HUD/CenterContainer/Control/RoundTimerLabel")

func start() -> void:
	round_timer.start()
	for p in players:
		p.active = true

func end() -> void:
	for p in players:
		p.active = false

func instance_player(id: int) -> void:
	var player_instance = Player.instance()
	player_instance.name = str(id)
	player_instance.set_network_master(id)
	players.append(player_instance)
	add_child(player_instance)
	# Randomize player position for testing
	# TO DO - replace this with actual spawn locations defined in the map
	player_instance.global_transform.origin = Vector3(
		rand_range(-5, 5),
		0,
		rand_range(-5, 5)
	)
