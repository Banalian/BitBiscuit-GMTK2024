class_name FailedStateHandler
extends Node2D

@onready var panel: Panel = $Panel
@onready var final_count_label: Label = $Panel/VBoxContainer/FinalCountLabel


func show_fail_state(final_score: int):
	print("Failed")
	panel.visible = true
	final_count_label.text = "Final Score : " + str(final_score) + " Order(s) Completed"


func _on_back_to_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")


func _on_button_quit_pressed() -> void:
	get_tree().quit()


func _on_game_manager_failed_state(failed_round: RefCounted, failed_round_number: int, final_score: int) -> void:
	show_fail_state(final_score)
