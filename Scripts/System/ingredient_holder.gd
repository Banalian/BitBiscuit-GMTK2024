extends Node


@export var root_node : Node

# Aimed to be <IngredientType, Ingredient>
var final_mix : Dictionary = {}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect_all_ingredients()
	pass # Replace with function body.
	

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
	pass


func add_ingredient(ingredient : Ingredient):
	if not final_mix.get_or_add(ingredient.ingredient_type, null):
		final_mix[ingredient.ingredient_type] = ingredient
		print("added" + ingredient.ingredient_name)
	pass


func remove_ingredient(ingredient : Ingredient):
	if final_mix.get_or_add(ingredient.ingredient_type, null) == ingredient:
		final_mix[ingredient.ingredient_type] = null
		print("removed" + ingredient.ingredient_name)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
