class_name IngredientHolder
extends Node
signal holding_mix_changed(new_holding_mix)

@export var root_node : Node

var holding_mix : Mix


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect_all_ingredients()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func connect_all_ingredients():
	var buttons = []
	for child in root_node.get_children():
		if child is IngredientButton:
			buttons.append(child)
	# manually connect their signal to us
	for button in buttons :
		var ing_button = button as IngredientButton
		ing_button.connect(ing_button.added_ingredient.get_name(), add_ingredient)
		ing_button.connect(ing_button.removed_ingredient.get_name(), remove_ingredient)


func add_ingredient(ingredient : Ingredient):
	if holding_mix.add(ingredient):
		holding_mix_changed.emit(holding_mix)
		print("Added " + ingredient.ingredient_name + " To the holder")


func remove_ingredient(ingredient : Ingredient):
	if holding_mix.remove(ingredient):
		print("Removed " + ingredient.ingredient_name + " from the holder")
		holding_mix_changed.emit(holding_mix)


# Used when clicking a client tile
func extract_mix():
	if not holding_mix.get_or_add(Constants.IngredientType.CONTAINER, null):
		# Means it's not a valid mix yet
		return null
	var extracted_mix = holding_mix
	holding_mix = Mix.new()
	holding_mix_changed.emit(holding_mix)
	return extracted_mix


# Used when trying to take an existing mix from a client tile
func import_mix(mix : Mix):
	if holding_mix.get_or_add(Constants.IngredientType.CONTAINER, null):
		# We already have a mix, refuse it
		return false
	holding_mix = mix
	holding_mix_changed.emit(holding_mix)
	return true
