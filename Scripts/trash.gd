extends Button

signal mix_thrashed(trashed_mix)

@export var holder : IngredientHolder

@onready var main = $"../.."


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func try_trash_mix():
	var tmp_mix = holder.extract_mix()
	if tmp_mix:
		mix_thrashed.emit(tmp_mix)
		print("trash took the mix")
	# else, couldn't extract because the mix is invalid, do nothing
		main.audio_stream.stream = load("res://Assets/Sounds/TrashCan.mp3")
		main.audio_stream.pitch_scale = 0.8 + (randi() % 11) / 25.0
		main.audio_stream.play()


func _on_trash_tile_pressed():
	try_trash_mix()
