extends StaticBody

# TO DO - update this when real meshes are defined
# Also make sure "local to scene" is enabled on the material for glow to work
onready var mesh_array = [
	$MeshInstance
]

# TO DO - replace this with the desired item
var item_type = preload("res://scenes/item.tscn")

func glow_enable() -> void:
	for mesh_instance in mesh_array:
		mesh_instance.mesh.surface_get_material(0).emission_energy = 0.05

func glow_disable() -> void:
	for mesh_instance in mesh_array:
		mesh_instance.mesh.surface_get_material(0).emission_energy = 0.0

func pick_up(player_id: String) -> void:
	rpc("spawn_item", player_id)

sync func spawn_item(player_id: String) -> void:
	var item_instance = item_type.instance()
	Network.game.add_child(item_instance)
	item_instance.pick_up(player_id)
