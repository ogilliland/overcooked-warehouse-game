extends Node

onready var pickup_sounds = [
	"res://sounds/pickup1.mp3",
	"res://sounds/pickup2.mp3",
]

onready var pickup_player: AudioStreamPlayer = $PickUp
onready var coins_player: AudioStreamPlayer = $Coins


func play_pickup():
	var stream = pickup_sounds[randi() % pickup_sounds.size()]
	var vstream = load(stream)
	pickup_player.set_stream(vstream)
	pickup_player.play()


func play_coins():
	coins_player.play()
