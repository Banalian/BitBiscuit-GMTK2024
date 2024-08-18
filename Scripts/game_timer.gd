class_name GameTimer
extends Node2D

@export var base_time:= 60.0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Label.text = "Time: %d:%02d" % [floor($Timer.time_left / 60), int($Timer.time_left) % 60]
	pass


func start_timer(time:= -1.0):
	# start timer with base time if none give, else we use the given time
	$Timer.start(base_time if time < 0.0 else time )

func pause_timer():
	$Timer.paused = true
	
func resume_timer():
	$Timer.paused = false
