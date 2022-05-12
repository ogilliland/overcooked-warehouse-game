extends Spatial

# TO DO - update this when real meshes are defined
# Also make sure "local to scene" is enabled on the material for glow to work
onready var mesh_array = [
	$MeshInstance
]

onready var held_item: Spatial = $HeldItem

func glow_enable() -> void:
	for mesh_instance in mesh_array:
		mesh_instance.mesh.surface_get_material(0).emission_energy = 0.05

func glow_disable() -> void:
	for mesh_instance in mesh_array:
		mesh_instance.mesh.surface_get_material(0).emission_energy = 0.0

func pick_up(player: KinematicBody) -> void:
	if has_item():
		var item = held_item.get_child(0)
		item.pick_up(player)

func place(player: KinematicBody) -> void:
	if not has_item():
		var item = player.held_item.get_child(0)
		item.place(self)

func has_item() -> bool:
	return (not held_item.get_child_count() == 0)
