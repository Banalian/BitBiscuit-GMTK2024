extends Button

@export var ingredient_res : Ingredient

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = ingredient_res.ingredient_name
	icon = ingredient_res.ingredient_texture
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
