extends Node2D

signal plus_range(num:float)
signal plus_dmg(num:int)
signal plus_lifesteal(num:float)

var plus_range_upgrades = 0
var plus_dmg_upgrades = 0
var plus_lifesteal_upgrades = 0

@onready var screen: CanvasLayer = $CanvasLayer

func _on_button_pressed() -> void:
	plus_range_upgrades += 0.2
	plus_range.emit(plus_range_upgrades)
	screen.visible = false

func _on_button_2_pressed() -> void:
	plus_dmg_upgrades += 10
	plus_range.emit(plus_dmg_upgrades)
	screen.visible = false

func _on_button_3_pressed() -> void:
	plus_lifesteal_upgrades += 0.08
	plus_lifesteal.emit(plus_lifesteal_upgrades)
	screen.visible = false
