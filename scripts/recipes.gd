extends Node

onready var ingredients = [
	preload("res://scenes/tomato.tscn"),
	preload("res://scenes/broccoli.tscn"),
	preload("res://scenes/carrot.tscn"),
	preload("res://scenes/steak.tscn"),
	preload("res://scenes/turkey.tscn")
]

var ingredient_scenes: Array

var recipes: Array = []

func _ready() -> void:
	_randomize()

# [ 2, 1, 2, 0, 0, 1, 2, 1]

# on box complete, pop from visible, push from invisible to visible

# [0, 2, 1]

# queue of 100 boxes, you peek the first 3

# TO DO - randomize recipes from server at start of game?
func _randomize() -> void:
	for packed_scene in ingredients:
		ingredient_scenes.append(packed_scene.instance())
	
	recipes.append({
		"color": Color(1, 0, 0),
		"ingredients": [
			ingredient_scenes[0],
			ingredient_scenes[1],
			ingredient_scenes[4]
		],
		"type": "red"
	})
	recipes.append({
		"color": Color(0, 1, 0),
		"ingredients": [
			ingredient_scenes[1],
			ingredient_scenes[2],
			ingredient_scenes[3]
		],
		"type": "green"
	})
	recipes.append({
		"color": Color(0, 0, 1),
		"ingredients": [
			ingredient_scenes[1],
			ingredient_scenes[3],
			ingredient_scenes[4]
		],
		"type": "blue"
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
