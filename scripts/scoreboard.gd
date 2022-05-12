extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var score = 0

sync func _add_score(val: int) -> void:
	score += val
	print(score)

func add_score(item: Node) -> void:
	var score = 10
	
	# TODO calculate score of a box
	
	rpc("_add_score", score)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
