class_name IngredientButton
extends Node

signal added_ingredient (ingredient: Ingredient)
signal removed_ingredient (ingredient: Ingredient)

@export var ingredient_res: Ingredient
@export var button: Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button.text = ingredient_res.ingredient_name
	button.icon = ingredient_res.ingredient_texture
	if ingredient_res.ingredient_scene:
		var scene = ingredient_res.ingredient_scene.instantiate() as Node2D
		add_child(scene)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func add_ingredient():
	added_ingredient.emit(ingredient_res)


func remove_ingredient():
	removed_ingredient.emit(ingredient_res)


func _on_Button_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		match event.button_index:
			MOUSE_BUTTON_LEFT :
				add_ingredient()
			MOUSE_BUTTON_RIGHT:
				remove_ingredient()


func toggle_ingredient_button_state():
	button.disabled = not button.disabled
