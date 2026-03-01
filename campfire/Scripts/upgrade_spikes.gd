extends Node2D

@onready var screen: CanvasLayer = $CanvasLayer

func _on_button_pressed() -> void:
	Global.spikes += 1
	screen.visible = false

func _on_button_2_pressed() -> void:
	Global.burst_chance += 10
	screen.visible = false

func _on_button_3_pressed() -> void:
	Global.spike_burst_cd -= 0.5
	screen.visible = false

func _on_character_body_2d_up_spikes() -> void:
	screen.visible = true
