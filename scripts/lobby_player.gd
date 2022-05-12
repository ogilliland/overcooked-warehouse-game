extends Control

func refresh() -> void:
	# Draw silhouette if player is missing
	# Or full player model if they've joined
	if $PlayerName.text == "":
		$ViewportContainer/Viewport.own_world = true
	else:
		$ViewportContainer/Viewport.own_world = false
