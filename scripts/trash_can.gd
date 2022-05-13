extends Spatial

export(Array, NodePath) var mesh_array = []

func glow_enable() -> void:
	for mesh_path in mesh_array:
		var mesh_instance = get_node(mesh_path)
		for surface_id in range(mesh_instance.get_surface_material_count()):
			mesh_instance.get_surface_material(surface_id).emission_energy = 0.25

func glow_disable() -> void:
	for mesh_path in mesh_array:
		var mesh_instance = get_node(mesh_path)
		for surface_id in range(mesh_instance.get_surface_material_count()):
			mesh_instance.get_surface_material(surface_id).emission_energy = 0.0


func place(player: KinematicBody) -> void:
	var player_item = player.held_item.get_child(0)
	player_item.destroy()
