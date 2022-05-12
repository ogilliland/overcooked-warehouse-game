extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func populate(recipe):
	$HBoxContainer/RecipeColor.color = recipe.color
	$HBoxContainer/Ingredient1.texture = recipe.ingredients[0].twoD_icon
	$HBoxContainer/Ingredient2.texture = recipe.ingredients[1].twoD_icon
	$HBoxContainer/Ingredient3.texture = recipe.ingredients[2].twoD_icon
