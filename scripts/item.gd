extends Spatial

onready var area: Area = $InteractArea

var is_held: bool = false

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

func pick_up(player_id: String) -> void:
	if not is_held:
		rpc("update_parent", player_id+"/HeldItem", Vector3(0, 0, 0), 2, true)

func put_down() -> void:
	if is_held:
		var new_position = global_transform.origin
		new_position.y = 0
		rpc("update_parent", ".", new_position, 1, false)

func place(target: Spatial) -> void:
	if is_held:
		rpc("update_parent", target.name+"/HeldItem", Vector3(0, 0, 0), 2, false)

func insert_into(target: Spatial, path: String) -> void:
	if is_held:
		var item_container = target.held_item.get_child(0)
		var num_children = item_container.children_container.get_child_count() + 1
		if num_children <= item_container.MAX_ITEMS:
			var offset = item_container.find_offset(num_children)
			rpc("update_parent", target.name+path+"/Children", Vector3(0, 0.5, 0) + offset, 2, false)

func destroy_and_score() -> void:
#	rpc("add_score", 10) # TO DO - define scoring rules, should be a separate script
	rpc("_destroy")

func destroy() -> void:
	rpc("_destroy")

sync func _destroy() -> void:
	queue_free()

sync func update_parent(node_path: String, new_position: Vector3, new_collision_layer: int, new_is_held: bool) -> void:
	get_parent().remove_child(self)
	var new_parent = Network.game.get_node(node_path)
	new_parent.add_child(self)
	translation = new_position
	# Prevent held items from interfering with player raycast
	area.collision_layer = new_collision_layer
	area.collision_mask = new_collision_layer
	# Tracking state
	is_held = new_is_held
