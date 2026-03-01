extends Node2D
@onready var screen: CanvasLayer = $CanvasLayer

func _on_button_pressed() -> void:
	Global.tent_range += 0.1
	screen.visible = false
	

func _on_button_2_pressed() -> void:
	Global.knockback_dist += 100
	screen.visible = false

func _on_button_3_pressed() -> void:
	Global.dot += 3
	Global.dot_duration += 1.5
	screen.visible = false
