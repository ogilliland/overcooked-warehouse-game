extends "res://scripts/item_container.gd"

var full: bool = false


func find_offset(num_children: int) -> Vector3:
	var offset = Vector3(0, 0.5, 0)
	match num_children:
		1:
			offset += Vector3(0, 0, 0)
		2:
			offset += Vector3(0.5, 0, 0)
		3:
			offset += Vector3(-0.5, 0, 0)
	return offset
