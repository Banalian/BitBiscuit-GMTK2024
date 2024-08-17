extends Node

@export var root_node: Node
@export var mix_displayer: MixDisplayer
# Chance to need an additonal ingredient from the additional type
@export var additional_chance:= .75

# Dictionary<IngredientType, Dictionary<MixType, Array<Ingredients>>>
var _available_ingredients = {
	Constants.IngredientType.CONTAINER:{
		Constants.MixType.SOLID : [],
		Constants.MixType.LIQUID : []
	},
	Constants.IngredientType.BASE:{
		Constants.MixType.SOLID : [],
		Constants.MixType.LIQUID : []
	},
	Constants.IngredientType.ADDITIONAL:{
		Constants.MixType.SOLID : [],
		Constants.MixType.LIQUID : []
	}
}

var _processed_ingredients = []


func _ready() -> void:
	process_ingredients()
	# to test for now
	mix_displayer.set_mix(generate_random_mix(Constants.MixType.SOLID))


func generate_random_mix(type: Constants.MixType):
	var final_mix = Mix.new()
	final_mix.add(_get_random_ing_in_array(_available_ingredients[Constants.IngredientType.CONTAINER][type]))
	final_mix.add(_get_random_ing_in_array(_available_ingredients[Constants.IngredientType.BASE][type]))
	if randf() < additional_chance:
		final_mix.add(_get_random_ing_in_array(_available_ingredients[Constants.IngredientType.ADDITIONAL][type]))
	return final_mix

func process_ingredients():
	var ingredients = _get_available_ingredients()
	# for each ingredient available
	for ing in ingredients:
		var ingredient = ing as Ingredient
		# Continue if we've already processed it
		if ingredient in _processed_ingredients:
			continue
		var type = ingredient.ingredient_type
		# If it's used in all, add to both mixtype
		if ingredient.used_in == Constants.MixType.ALL:
			_available_ingredients[type][Constants.MixType.SOLID].append(ingredient)
			_available_ingredients[type][Constants.MixType.LIQUID].append(ingredient)
		# Else only add it to the corresponding type
		else:
			if ingredient.used_in == Constants.MixType.SOLID:
				_available_ingredients[type][Constants.MixType.SOLID].append(ingredient)
			else:
				_available_ingredients[type][Constants.MixType.LIQUID].append(ingredient)
		_processed_ingredients.append(ingredient)


func _get_random_ing_in_array(array: Array):
	return array[randi() % array.size()]


# Get ingredients available in the current level to determine what can be done
func _get_available_ingredients():
	var ingredients := []
	for child in root_node.get_children():
		if child is IngredientButton:
			ingredients.append(child.ingredient_res as Ingredient)
	return ingredients
