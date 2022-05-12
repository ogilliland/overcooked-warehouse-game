extends Spatial

export var rotation_speed: float = 0.1

func _physics_process(delta: float) -> void:
	rotation.y -= rotation_speed * delta
