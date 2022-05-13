extends Control

onready var BoxRow = preload("res://scenes/single_box_display.tscn")
onready var BoxesTable = $Margin/BoxesTable

# Called when the node enters the scene tree for the first time.
func _ready():
	BoxInit.box_display = self
	populate()

func populate():
	var children = BoxesTable.get_children()
	for child in children:
#		BoxesTable.remove_child(child)
		child.queue_free()
	for box in BoxInit.visible_boxes:
		var newRow = BoxRow.instance()
		newRow.populate(box)
		BoxesTable.add_child(newRow)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
