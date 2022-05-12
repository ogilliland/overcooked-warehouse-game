extends Control

onready var recipeRow = preload("res://scenes/single_recipe_display.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	for recipe in Recipes.recipes:
		var newRow = recipeRow.instance()
		newRow.populate(recipe)
		$RecipesTable.add_child(newRow)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
