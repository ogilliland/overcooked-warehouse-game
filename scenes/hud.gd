extends HBoxContainer

export var round_timer_path: NodePath

func get_round_timer() -> Node:
	return get_node(round_timer_path)
