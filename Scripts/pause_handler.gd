extends Node


@export var _timers: Array[Timer]
@onready var _panel = $Panel

var _paused:= false
var _old_timer_state: Array[bool] = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func toggle_pause():
	_paused = not _paused
	# if pausing, save old state to restore after
	if _paused:
		_old_timer_state = []
	_panel.visible = _paused
	var index = 0
	for timer in _timers:
		if _paused:
			_old_timer_state.append(timer.paused)
			timer.paused = true
		else:
			timer.paused = _old_timer_state[index]
		index += 1


func _unhandled_input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE or event.keycode == KEY_P:
			toggle_pause()
