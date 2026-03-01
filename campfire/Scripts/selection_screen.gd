extends Node2D

signal choose_tentacles_signal
signal choose_spikes_signal
signal choose_glutton_signal
@onready var selection_screen: CanvasLayer = $CanvasLayer

func _ready():
	get_tree().paused = true
	selection_screen.visible = true

func _on_button_pressed() -> void:
	selection_screen.visible = false
	choose_tentacles_signal.emit()
	get_tree().paused = false

func _on_button_2_pressed() -> void:
	selection_screen.visible = false
	choose_glutton_signal.emit()
	get_tree().paused = false

func _on_button_3_pressed() -> void:
	selection_screen.visible = false
	choose_spikes_signal.emit()
	get_tree().paused = false
