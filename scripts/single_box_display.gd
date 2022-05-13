extends Control

const colorDict = {
	"red": Color(255, 0, 0),
	"green": Color(0, 255, 0),
	"blue": Color(0, 0, 255)
}
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func populate(box):
	$MarginContainer/HBoxContainer/RecipeColor.material.set_shader_param("blend_color", colorDict[box.recipes[0]])
	$MarginContainer/HBoxContainer/RecipeColor2.material.set_shader_param("blend_color", colorDict[box.recipes[1]])
	$MarginContainer/HBoxContainer/RecipeColor3.material.set_shader_param("blend_color", colorDict[box.recipes[2]])
