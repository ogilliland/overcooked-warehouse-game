extends Node

var invisible_boxes: Array
var visible_boxes: Array

const recipes_available = ["red"]
#const recipes_available = ["red", "green", "blue", "orange"]


func _ready():
	for _i in range(100):
		var recipe1 = recipes_available[randi() % recipes_available.size()]
		var recipe2 = recipes_available[randi() % recipes_available.size()]
		var recipe3 = recipes_available[randi() % recipes_available.size()]
		invisible_boxes.append({"recipes": [recipe1, recipe2, recipe3]})

	visible_boxes.append(invisible_boxes.pop_front())
	visible_boxes.append(invisible_boxes.pop_front())
	visible_boxes.append(invisible_boxes.pop_front())

	print(visible_boxes)


func check_box_done(box: Node):
	var items = box.get_children()
	var types: Array
	for item in items:
		types.append(item.type)


func next_box(done: int):
	visible_boxes.remove(done)
	visible_boxes.append(invisible_boxes.pop_front())


func check_box(box: Spatial) -> bool:
	print("box is checked")
	var box_recipes = box.get_contents()
	for visible_box in visible_boxes:
		var remaining = [] + visible_box.recipes
		for recipe in box_recipes:
			for remaining_recipe in remaining:
				if remaining_recipe == recipe.type:
					remaining.erase(recipe.type)

		if remaining.size() == 0:
			print_debug("Box is valid!")
			return true
	return false
