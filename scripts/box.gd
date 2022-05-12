extends "res://scripts/item_container.gd"

func find_offset(num_children: int) -> Vector3:
	match num_children:
		1:
			return Vector3(0, 0, 0)
		2:
			return Vector3(0, 0, 0.5)
		3:
			return Vector3(0, 0, -0.5)
	return Vector3(0, 0, 0)
