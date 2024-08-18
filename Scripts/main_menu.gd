extends Node2D

@onready var game_logo_top = $GameLogo/GameLogoTop
@onready var game_logo_bottom = $GameLogo/GameLogoBottom
@onready var camera = $Camera2D


func _process(delta: float) -> void:
	game_logo_bottom.position.y = game_logo_top.position.y + 15.0 + sin(Time.get_ticks_msec() / 750.0) * 2.1


func _on_button_play_pressed() -> void:
	var transition_tween = create_tween().set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_IN)
	transition_tween.tween_property(camera, "position", Vector2(160.0, 270.0), 1.0)
	await transition_tween.finished
	get_tree().change_scene_to_file("res://Scenes/main.tscn")


func _on_button_quit_pressed() -> void:
	get_tree().quit()


func _on_button_gmtk_pressed() -> void:
	OS.shell_open("https://banalian.itch.io/bar-of-demanding-gods")
