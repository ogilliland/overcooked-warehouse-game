extends "res://scripts/item_container.gd"

var full: bool = false

# TO DO - replace this with a signal instead of checking every frame
func _physics_process(delta: float) -> void:
	if not full:
		if get_contents().size() == 3:
			print(Recipes.check_recipe(self))
			full = true
