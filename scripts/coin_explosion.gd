extends Particles

func _on_timeout():
	queue_free()
