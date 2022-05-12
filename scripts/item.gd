extends Spatial

onready var area: Area = $Area

var is_held: bool

# TO DO - update this when real meshes are defined
# Also make sure "local to scene" is enabled on the material for glow to work
onready var mesh_array = [
	$MeshInstance
]

# TO DO - synchronise item positions when new player connects?
# Or we can avoid this by starting all players at same state (lobby) and hoping for no desync!

func glow_enable() -> void:
	for mesh_instance in mesh_array:
		mesh_instance.mesh.surface_get_material(0).emission_energy = 0.05

func glow_disable() -> void:
	for mesh_instance in mesh_array:
		mesh_instance.mesh.surface_get_material(0).emission_energy = 0.0

func pick_up(player: KinematicBody) -> void:
	if not is_held:
		rpc("update_parent", player.name, Vector3(0, 0, 0), 2)

func put_down(target: Spatial = null) -> void:
	if is_held:
		var player_position = get_parent().get_parent().transform.origin
		rpc("update_parent", Network.game, player_position, 1)

sync func update_parent(player_id: String, new_position: Vector3, new_collision_layer: int) -> void:
	get_parent().remove_child(self)
	var new_parent = Network.game.get_node(player_id).held_item
	new_parent.add_child(self)
	translation = new_position
	# Prevent held items from interfering with player raycast
	area.collision_layer = new_collision_layer
	area.collision_mask = new_collision_layer
