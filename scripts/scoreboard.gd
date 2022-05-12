extends Label

var score = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



sync func _add_score(val: int) -> void:
	score += val
	text = "Score: %s" % score
	print(score)

func add_score() -> void:
	var value = 10
	_add_score(value)
	# TODO calculate score of a box
	
	rpc("_add_score", score)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# Just for testing the scoreboard UI! Toggle TestAddPoints to visible!
func _on_TestAddPoints_pressed():
	add_score()
	pass # Replace with function body.
