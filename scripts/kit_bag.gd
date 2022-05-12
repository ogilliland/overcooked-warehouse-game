extends "res://scripts/item_container.gd"

var full: bool = false

# TO DO - replace this with a signal instead of checking every frame
func _physics_process(delta: float) -> void:
	if not full:
		if get_contents().size() == 3:
			var built_recipe = Recipes.check_recipe(self)
			type = built_recipe.type
			full = true
