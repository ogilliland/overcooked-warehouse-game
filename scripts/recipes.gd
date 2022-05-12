extends Node

onready var ingredients = [
	preload("res://scenes/tomato.tscn")
]

var ingredient_scenes: Array

var recipes: Array = []

func _ready() -> void:
	_randomize()

# TO DO - randomize recipes from server at start of game?
func _randomize() -> void:
	for packed_scene in ingredients:
		ingredient_scenes.append(packed_scene.instance())
	
	recipes.append({
		"color": Color(255, 0, 0),
		"ingredients": [
			ingredient_scenes[0],
			ingredient_scenes[0],
			ingredient_scenes[0]
		]
	})

func check_recipe(kit_bag: Spatial) -> Dictionary:
	var kit_bag_ingredients = kit_bag.get_contents()
	for recipe in recipes:
		var remaining_ingredients = [] + recipe.ingredients
		for kit_ingredient in kit_bag_ingredients:
			for recipe_ingredient in remaining_ingredients:
				if kit_ingredient.type == recipe_ingredient.type:
					remaining_ingredients.erase(recipe_ingredient)
		if remaining_ingredients.size() == 0:
			# Exact match
			print_debug("Kitbag is a valid recipe!")
			return recipe
	return {}
