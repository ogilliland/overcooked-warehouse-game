tool
extends Control

signal pressed

onready var inner_label = $Label

export var text: String = "" setget set_text

func set_text(new: String) -> void:
	text = new
	if inner_label:
		inner_label.text = text

func _ready() -> void:
	if inner_label:
		inner_label.text = text

func _gui_input(event: InputEvent):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if event.pressed:
			emit_signal("pressed")
