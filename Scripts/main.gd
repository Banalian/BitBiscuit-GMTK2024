class_name Main
extends Node

var view_shift := false

@onready var camera_base = $CameraBase
@onready var camera = $CameraBase/Camera2D
@onready var client = $ViewTop/Client
@onready var dialogue = $ViewTop/DialogueBackground/MarginContainer/VBoxContainer/DialogueText
@onready var next_dialogue_timer = $ViewTop/NextDialogueTimer
@onready var audio_stream = $AudioStreamPlayer

var dialogue_tween
var client_tween

# contains strings
var _dialogue_list:= []
var _current_dialogue:= 0

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

# returns the amount of time the whole start sequence will take
func start_client(mixes: Array[Mix]) -> float :
	_dialogue_list = []
	_current_dialogue = 0
	add_client()
	client.randomize()
	_dialogue_list.append(client.get_dialogue(0))
	_dialogue_list.append(client.get_dialogue(1, mixes))
	set_dialogue(client.get_dialogue(0))
	next_dialogue_timer.stop()
	next_dialogue_timer.start()
	return 1.0 # only an estimation

# returns the amount of time the whole end sequence will take
func end_client() -> float :
	_dialogue_list = []
	_current_dialogue = 0
	remove_client()
	_dialogue_list.append(client.get_dialogue(2))
	_dialogue_list.append(client.get_dialogue(3))
	set_dialogue(_dialogue_list[_current_dialogue])
	next_dialogue_timer.stop()
	next_dialogue_timer.start()
	return 2.0


func _on_next_dialogue_timer_timeout() -> void:
	_current_dialogue += 1
	if (_current_dialogue) < _dialogue_list.size():
		set_dialogue(_dialogue_list[_current_dialogue])
		next_dialogue_timer.start()


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
