class_name IngredientHolder
extends Node

signal holding_mix_changed(new_holding_mix)

@export var root_node: Node

var holding_mix: Mix = null
var _connected_buttons:= []

@onready var main = $".."


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect_all_ingredients()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func connect_all_ingredients():
	var buttons: Array[IngredientButton] = []
	for child in root_node.find_children("*", "IngredientButton"):
		if child is IngredientButton:
			buttons.append(child)
	# manually connect their signal to us, if it's not already done
	for button in buttons :
		if not button in _connected_buttons:
			button.connect(button.added_ingredient.get_name(), add_ingredient)
			button.connect(button.removed_ingredient.get_name(), remove_ingredient)
			_connected_buttons.append(button)


func add_ingredient(ingredient: Ingredient):
	var tmp_mix : Mix = holding_mix if holding_mix else null
	if not tmp_mix:
		tmp_mix = Mix.new()
	if tmp_mix.add(ingredient):
		holding_mix = tmp_mix
		holding_mix_changed.emit(holding_mix)
		print("Added " + ingredient.ingredient_name + " To the holder")
		main.audio_stream.stream = ingredient.station_sound
		main.audio_stream.pitch_scale = 0.8 + (randi() % 11) / 25.0
		main.audio_stream.play()


func remove_ingredient(ingredient: Ingredient):
	var tmp_mix : Mix = holding_mix if holding_mix else null
	if not tmp_mix:
		tmp_mix = Mix.new()
	if tmp_mix.remove(ingredient):
		holding_mix = tmp_mix
		holding_mix_changed.emit(holding_mix)
		print("Removed " + ingredient.ingredient_name + " from the holder")


# Used when clicking a client tile
func extract_mix():
	if not holding_mix or holding_mix.is_mix_empty():
		# Means it's not a valid mix yet
		return null
	var extracted_mix = holding_mix
	holding_mix = null
	holding_mix_changed.emit(holding_mix)
	return extracted_mix


# Used when trying to take an existing mix from a client tile
func import_mix(mix: Mix):
	if holding_mix:
		# We already have a mix, refuse it
		return false
	holding_mix = mix
	holding_mix_changed.emit(holding_mix)
	return true
