extends Resource
class_name Ingredient

# used_in is not important to set for additional ingredients
@export var used_in: Constants.MixType
@export var ingredient_type: Constants.IngredientType
@export var ingredient_name:= "Invalid"
@export var ingredient_texture: Texture2D
@export var ingredient_station: Texture2D
@export var station_sound: AudioStream
@export var ingredient_scene: PackedScene
