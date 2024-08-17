extends Node

var view_shift := false

@onready var camera = $Camera2D


func _on_view_button_pressed() -> void:
	view_shift = not view_shift
	if view_shift:
		camera.position.y = 270
	else:
		camera.position.y = 90
