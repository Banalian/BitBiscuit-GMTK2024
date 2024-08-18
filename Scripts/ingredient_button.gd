class_name IngredientButton
extends Button

signal added_ingredient (ingredient: Ingredient)
signal removed_ingredient (ingredient: Ingredient)

@export var ingredient_res: Ingredient

func _ready() -> void:
	tooltip_text = ingredient_res.ingredient_name
	icon = ingredient_res.ingredient_station


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
	disabled = not disabled
