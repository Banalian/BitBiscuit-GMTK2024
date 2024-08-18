extends Node


@export var _timers: Array[Timer]
@onready var _panel = $Panel
var _paused:= false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func toggle_pause():
	_paused = not _paused
	_panel.visible = _paused
	for timer in _timers:
		timer.paused = _paused


func _unhandled_input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE or event.keycode == KEY_P:
			toggle_pause()
