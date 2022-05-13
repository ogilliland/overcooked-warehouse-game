extends Spatial

onready var coin_explosion = preload("res://scenes/coin_explosion.tscn")

onready var area: Area = $InteractArea
export var type: String
export var twoD_icon: StreamTexture

var is_held: bool = false

var base_emission: float = 0.0
var active_emission: float = 0.25

export(Array, NodePath) var mesh_array = []

func glow_enable() -> void:
	for mesh_path in mesh_array:
		var mesh_instance = get_node(mesh_path)
		for surface_id in range(mesh_instance.get_surface_material_count()):
			mesh_instance.get_surface_material(surface_id).emission_energy = active_emission

func glow_disable() -> void:
	for mesh_path in mesh_array:
		var mesh_instance = get_node(mesh_path)
		for surface_id in range(mesh_instance.get_surface_material_count()):
			mesh_instance.get_surface_material(surface_id).emission_energy = base_emission

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
	if BoxInit.check_box(self):
#		Scoreboard.add_score(self)
		var particles_instance = coin_explosion.instance()
		Network.game.add_child(particles_instance)
		particles_instance.global_transform.origin = global_transform.origin
		particles_instance.emitting = true
		Scoreboard.add_score()
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
