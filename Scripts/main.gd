extends Node

var view_shift := false

@onready var camera = $Camera2D
@onready var dialogue = $ViewTop/DialogueBackground/DialogueText


func _ready() -> void:
	dialogue.visible_ratio = 0.0
	var tween = get_tree().create_tween()
	tween.tween_property(dialogue, "visible_ratio", 1.0, dialogue.get_parsed_text().length() / 25.0)


func _on_view_button_pressed() -> void:
	view_shift = not view_shift
	if view_shift:
		camera.position.y = 270.0
	else:
		camera.position.y = 90.0
