extends Spatial


# TO DO - update this when real meshes are defined
# Also make sure "local to scene" is enabled on the material for glow to work
onready var mesh_array = [
	$MeshInstance
]

func glow_enable() -> void:
	for mesh_instance in mesh_array:
		mesh_instance.mesh.surface_get_material(0).emission_energy = 0.05

func glow_disable() -> void:
	for mesh_instance in mesh_array:
		mesh_instance.mesh.surface_get_material(0).emission_energy = 0.0

func place(player: KinematicBody) -> void:
	var player_item = player.held_item.get_child(0)
	if player_item.is_in_group("boxes"):
		player_item.destroy_and_score()
