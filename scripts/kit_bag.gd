extends "res://scripts/item_container.gd"

var full: bool = false

# TO DO - replace this with a signal instead of checking every frame
func _physics_process(delta: float) -> void:
	if not full:
		if get_contents().size() == 3:
			var built_recipe = Recipes.check_recipe(self)
			if not built_recipe.empty():
				type = built_recipe.type
				base_emission = 0.5
				active_emission = 1.0
				var color = built_recipe.color
				for mesh_path in mesh_array:
					var mesh_instance = get_node(mesh_path)
					for surface_id in range(mesh_instance.get_surface_material_count()):
						mesh_instance.get_surface_material(surface_id).emission = color
						mesh_instance.get_surface_material(surface_id).emission_energy = base_emission
			full = true
