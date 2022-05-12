extends Label

signal round_over

export var total_round_time: String = "2:00"
export var panic_seconds_left: int = 20

onready var timer: Timer = $RoundTimer
onready var player: AnimationPlayer = $AnimationPlayer

var total_seconds: int


func init():
	var parts: Array = total_round_time.split(":")
	var minutes = int(parts[0])
	var seconds = int(parts[1])
	total_seconds = minutes * 60 + seconds


func start():
	init()
	timer.start()


func stop():
	timer.stop()
	player.get_animation("blink").loop = false
	emit_signal("round_over")


func stringify_time(seconds: int) -> String:
	return "%02d:%02d" % [seconds / 60, seconds % 60]


func _on_tick():
	total_seconds -= 1
	self.text = stringify_time(total_seconds)

	if total_seconds == panic_seconds_left:
		player.play("blink")

	if total_seconds == 0:
		stop()
