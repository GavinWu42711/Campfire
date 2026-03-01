extends Node2D

@onready var screen: CanvasLayer = $CanvasLayer
	
func _on_character_body_2d_up_gluttons_bite() -> void:
	get_tree().paused = true
	screen.visible = true

func _on_button_button_down() -> void:
	Global.bite_range += 0.2
	screen.visible = false
	get_tree().paused = false

func _on_button_2_button_down() -> void:
	Global.bite_damage += 10
	screen.visible = false
	get_tree().paused = false

func _on_button_3_button_down() -> void:
	Global.lifesteal += 0.08
	screen.visible = false
	get_tree().paused = false
