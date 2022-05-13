extends Node

var score = 0

var label: Label


# Called when the node enters the scene tree for the first time.
func _ready():
	pass  # Replace with function body.


sync func _add_score(val: int) -> void:
	score += val
#	text = "Score: %s" % score
	label.text = str(score)
	print_debug(score)
	Music.play_coins()


func add_score() -> void:
	var value = 10
	# TODO calculate score of a box

	rpc("_add_score", value)
