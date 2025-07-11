extends Node2D

func _on_easy_btn_pressed() -> void:
	Global.difficulty = "easy"
	get_tree().change_scene_to_file("res://game.tscn")

func _on_medium_btn_pressed() -> void:
	Global.difficulty = "medium"
	get_tree().change_scene_to_file("res://game.tscn")

func _on_hard_btn_pressed() -> void:
	Global.difficulty = "hard"
	get_tree().change_scene_to_file("res://game.tscn")

func _on_quit_btn_pressed() -> void:
	get_tree().quit()
