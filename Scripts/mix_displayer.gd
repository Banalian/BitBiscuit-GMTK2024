class_name MixDisplayer
extends VBoxContainer

@export var container_display: TextureRect
@export var base_display: TextureRect
@export var additional_display: TextureRect

# NEEDS TO BE SET IMMEDIATLY ON START
var ing_to_rect = {}

var _loaded_scene: Node2D

func _enter_tree() -> void:
	ing_to_rect = {
		Constants.IngredientType.CONTAINER: container_display,
		Constants.IngredientType.BASE: base_display,
		Constants.IngredientType.ADDITIONAL: additional_display
	}


func set_mix(new_mix: Mix):
	var tmp_container: Ingredient
	var tmp_base: Ingredient
	var tmp_additional: Ingredient
	if new_mix:
		tmp_container = new_mix.get_ingredient(Constants.IngredientType.CONTAINER)
		tmp_base = new_mix.get_ingredient(Constants.IngredientType.BASE)
		tmp_additional = new_mix.get_ingredient(Constants.IngredientType.ADDITIONAL)
	if tmp_container:
		set_display_ing(tmp_container)
	else:
		clear_display(Constants.IngredientType.CONTAINER)
	if tmp_base:
		set_display_ing(tmp_base)
	else:
		clear_display(Constants.IngredientType.BASE)
	if tmp_additional:
		set_display_ing(tmp_additional)
	else:
		clear_display(Constants.IngredientType.ADDITIONAL)


func clear_display(type: Constants.IngredientType):
	if type == Constants.IngredientType.ADDITIONAL and _loaded_scene:
		_loaded_scene.free()
		_loaded_scene = null
	_set_texture(ing_to_rect[type], null)


func set_display_ing(new_ing: Ingredient):
	_set_texture(ing_to_rect[new_ing.ingredient_type], new_ing.ingredient_texture)
	if new_ing.ingredient_type == Constants.IngredientType.ADDITIONAL:
		if _loaded_scene:
			_loaded_scene.free()
			_loaded_scene = null
		if new_ing.ingredient_scene:
			var offset:= Vector2(additional_display.get_parent_control().size.x/2, new_ing.ingredient_texture.get_size().y/2)
			_loaded_scene = new_ing.ingredient_scene.instantiate() as Node2D
			_loaded_scene.position = offset
			additional_display.add_child(_loaded_scene)


func _set_texture(texture_rect: TextureRect, new_texture:Texture2D):
	texture_rect.texture = new_texture
