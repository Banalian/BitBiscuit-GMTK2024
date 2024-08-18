extends Node

var view_shift := false

@onready var camera = $Camera2D
@onready var client = $ViewTop/Client
@onready var dialogue = $ViewTop/DialogueBackground/DialogueText

var dialogue_tween
var client_tween


func _ready() -> void:
	camera.position.y = -90.0
	camera.position_smoothing_enabled = false
	set_dialogue("")
	var transition_tween = create_tween().set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	transition_tween.tween_property(camera, "position", Vector2(160.0, 90.0), 1.0)
	await transition_tween.finished
	camera.position_smoothing_enabled = true


func set_dialogue(text) -> void:
	if dialogue_tween:
		dialogue_tween.kill()
	dialogue.visible_ratio = 0.0
	dialogue.text = str("[center]", text)
	dialogue_tween = create_tween()
	dialogue_tween.tween_property(dialogue, "visible_ratio", 1.0, dialogue.get_parsed_text().length() / 50.0)


func add_client() -> void:
	if client_tween:
		client_tween.kill()
	client.position.x = 249.0
	var types = [Tween.TRANS_ELASTIC, Tween.TRANS_BACK, Tween.TRANS_QUART, Tween.TRANS_CUBIC, Tween.TRANS_LINEAR]
	client.tween_type = types.pick_random()
	var client_tween = create_tween().set_trans(client.tween_type).set_ease(Tween.EASE_OUT)
	client_tween.tween_property(client, "position", Vector2(89.0, 49.0), 1.0)


func remove_client() -> void:
	if client_tween:
		client_tween.kill()
	var client_tween = create_tween().set_trans(client.tween_type).set_ease(Tween.EASE_IN)
	client_tween.tween_property(client, "position", Vector2(-160.0, 49.0), 1.0)


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Debug1"):
		add_client()
	if Input.is_action_just_pressed("Debug2"):
		remove_client()


func _on_view_button_pressed() -> void:
	view_shift = not view_shift
	if view_shift:
		camera.position.y = 270.0
	else:
		camera.position.y = 90.0


func _unhandled_input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_SPACE:
			_on_view_button_pressed()
