extends HBoxContainer

export var round_timer_path: NodePath

onready var time_up = $Center/CenterContainer/Middle/TimeUp

func get_round_timer() -> Node:
	return get_node(round_timer_path)


func _on_round_over():
	time_up.visible = true
