extends "res://scripts/item.gd"

const MAX_ITEMS: int = 3

onready var children_container = $Children

func find_offset(num_children: int) -> Vector3:
	return Vector3(0, 0.5, 0) * num_children

func get_contents() -> Array:
	return children_container.get_children()
