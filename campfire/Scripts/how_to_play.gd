extends Node2D

func _on_button_pressed() -> void:
	SceneHandler.transition_scene(SceneHandler.LEVEL.LEVEL_1)
