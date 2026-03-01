extends Node2D

func _on_button_pressed() -> void:
	SceneHandler.transition_scene(SceneHandler.LEVEL.LEVEL_1)

func _on_button_2_pressed() -> void:
	get_tree().quit()
