extends Node2D

@onready var screen: CanvasLayer = $CanvasLayer

func _on_button_pressed() -> void:
	Global.bite_range += 0.2
	screen.visible = false
	get_tree().paused = false

func _on_button_2_pressed() -> void:
	Global.bite_damage += 10
	screen.visible = false
	get_tree().paused = false

func _on_button_3_pressed() -> void:
	Global.lifesteal += 0.08
	screen.visible = false
	get_tree().paused = false
