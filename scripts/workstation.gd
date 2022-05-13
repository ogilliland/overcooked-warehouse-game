extends Spatial

onready var held_item: Spatial = $HeldItem

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


func pick_up(player_id: String) -> void:
	if has_item():
		var item = held_item.get_child(0)
		item.pick_up(player_id)

func place(player: KinematicBody) -> void:
	var player_item = player.held_item.get_child(0)
	if not has_item():
		player_item.place(self)
	else:
		var workstation_item = held_item.get_child(0)
		if workstation_item.is_in_group("item_containers"):
			if (player_item.is_in_group("ingredients") and workstation_item.is_in_group("kit_bags")) or (player_item.is_in_group("kit_bags") and workstation_item.is_in_group("boxes")):
				player_item.insert_into(self, "/HeldItem/"+workstation_item.name)

func has_item() -> bool:
	return (not held_item.get_child_count() == 0)
