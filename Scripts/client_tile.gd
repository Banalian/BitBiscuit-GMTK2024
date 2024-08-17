extends Button

signal client_mix_changed(new_client_mix)

@export var holder : IngredientHolder


var client_mix : Mix = null


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func try_give_mix():
	if client_mix and holder.import_mix(client_mix):
		client_mix = null
		client_mix_changed.emit(client_mix)
	# else, couldn't give a drink because the holder already has one, do nothing


func try_take_mix():
	var tmp_mix = holder.extract_mix()
	if tmp_mix:
		client_mix = tmp_mix
		client_mix_changed.emit(client_mix)
	# else, couldn't extract because the drink is invalid, do nothing


func _on_client_tile_pressed():
	# when the client tile is pressed
	if client_mix:
		try_give_mix()
	else:
		try_take_mix()
