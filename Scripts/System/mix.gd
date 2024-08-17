class_name Mix

# Aimed to be <IngredientType, Ingredient>
var _content: Dictionary = {}
var _type: Constants.MixType


# Returns true if the ingredient was accepted, false otherwise
func add(ingredient: Ingredient):
	var add_ing := false
	# if there's already something for this, don't accept it
	if not _content.get_or_add(ingredient.ingredient_type, null):
		# if it's a container, accept it
		if ingredient.ingredient_type == Constants.IngredientType.CONTAINER:
			add_ing = true
		else:
			# if there's a container
			if _content.get_or_add(Constants.IngredientType.CONTAINER, null):
				# if it's allowed for all types
				if ingredient.used_in == Constants.MixType.ALL\
				# or if it's valid with the currenty mix
				or (ingredient.used_in == _type):
					add_ing = true
	if add_ing:
		if ingredient.ingredient_type == Constants.IngredientType.CONTAINER:
			_type = ingredient.used_in
		_content[ingredient.ingredient_type] = ingredient
	return add_ing

# Returns true if the ingredient was removed, false otherwise
func remove(ingredient: Ingredient):
	var remove_ing := false
	var tmp_ing : Ingredient = _content.get_or_add(ingredient.ingredient_type, null)
	# if the ingredient exists, and is the same
	if tmp_ing and tmp_ing == ingredient:
		# if it's a container, only remove it there's nothing else
		if ingredient.ingredient_type == Constants.IngredientType.CONTAINER:
			if not _content.get_or_add(Constants.IngredientType.BASE, null)\
			and not _content.get_or_add(Constants.IngredientType.ADDITIONAL, null):
				remove_ing = true
		# else remove it
		else:
			remove_ing = true
	if remove_ing:
		_content[ingredient.ingredient_type] = null
	return remove_ing

func get_ingredient(type: Constants.IngredientType):
	return _content.get_or_add(type, null)


func is_mix_empty():
	return not _content.get_or_add(Constants.IngredientType.CONTAINER, null)\
	and not _content.get_or_add(Constants.IngredientType.BASE, null)\
	and not _content.get_or_add(Constants.IngredientType.ADDITIONAL, null)


func clear():
	_content = {}
