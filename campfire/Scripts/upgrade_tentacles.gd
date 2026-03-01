extends Node2D
@onready var screen: CanvasLayer = $CanvasLayer

signal plus_range(num:float)
signal plus_knockback(num:int)
signal plus_dot(num:int, duration: float)

var plus_range_upgrades = 0
var plus_knockback_upgrades = 0
var plus_dot_upgrades = 0

func _on_button_pressed() -> void:
	plus_range_upgrades += 0.2
	plus_range.emit(plus_range_upgrades)
	screen.visible = false
	

func _on_button_2_pressed() -> void:
	plus_knockback_upgrades += 100
	plus_knockback.emit(plus_knockback_upgrades)
	screen.visible = false

func _on_button_3_pressed() -> void:
	plus_dot_upgrades += 3
	plus_dot.emit(plus_dot_upgrades, plus_dot_upgrades / 2)
	screen.visible = false
