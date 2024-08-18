class_name Main
extends Node

var view_shift := false

@onready var camera_base = $CameraBase
@onready var camera = $CameraBase/Camera2D
@onready var client = $ViewTop/Client
@onready var dialogue = $ViewTop/DialogueBackground/MarginContainer/VBoxContainer/DialogueText

var dialogue_tween
var client_tween


func _ready() -> void:
	camera_base.position.y = -180.0
	camera.position_smoothing_enabled = false
	set_dialogue("")
	var transition_tween = create_tween().set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	transition_tween.tween_property(camera_base, "position", Vector2(0.0, 0.0), 1.0)
	await transition_tween.finished
	camera.position_smoothing_enabled = true


func set_dialogue(text) -> void:
	if dialogue_tween:
		dialogue_tween.kill()
	dialogue.visible_ratio = 0.0
	dialogue.text = str("[center]", text)
	dialogue_tween = create_tween()
	dialogue_tween.tween_property(dialogue, "visible_ratio", 1.0, 0.5)


func add_client() -> void:
	if client_tween:
		client_tween.kill()
	client.position.x = 249.0
	var types = [Tween.TRANS_ELASTIC, Tween.TRANS_BACK, Tween.TRANS_QUART, Tween.TRANS_CUBIC, Tween.TRANS_LINEAR]
	client.tween_type = types.pick_random()
	var client_tween = create_tween().set_trans(client.tween_type).set_ease(Tween.EASE_OUT)
	client_tween.tween_property(client, "position", Vector2(89.0, 49.0), 0.8)


func remove_client() -> void:
	if client_tween:
		client_tween.kill()
	var client_tween = create_tween().set_trans(client.tween_type).set_ease(Tween.EASE_IN)
	client_tween.tween_property(client, "position", Vector2(-160.0, 49.0), 0.8)


func start_client(mixes: Array[Mix]):
	add_client()
	client.randomize()
	set_dialogue(client.get_dialogue(0))

# returns the amount of time the whole end sequence will take
func end_client() -> float :
	remove_client()
	set_dialogue(client.get_dialogue(3))
	return 1.0


#func _input(event: InputEvent) -> void:
	#if Input.is_action_just_pressed("Debug1"):
		#client.randomize()
	#if Input.is_action_just_pressed("Debug2"):
		#set_dialogue(client.get_dialogue(1, ["ASDF", "dessert??"]))


func _on_view_button_pressed() -> void:
	view_shift = not view_shift
	if view_shift:
		camera_base.position.y = 180.0
	else:
		camera_base.position.y = 0.0


func _unhandled_input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_SPACE:
			_on_view_button_pressed()
