extends StaticBody

# TO DO - replace this with the desired item
export var item_type: PackedScene

export(Array, NodePath) var mesh_array = []

func _ready() -> void:
	for i in range(3):
		var display = item_type.instance()
		display.is_held = true
		add_child(display)
		display.translation += Vector3(0, 0.5, 0) * i

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
	rpc("spawn_item", player_id)

sync func spawn_item(player_id: String) -> void:
	var item_instance = item_type.instance()
	Network.game.add_child(item_instance)
	item_instance.pick_up(player_id)
