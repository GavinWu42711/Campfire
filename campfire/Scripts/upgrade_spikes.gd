extends Node2D

@onready var screen: CanvasLayer = $CanvasLayer

signal plus_spikes(num:int)
signal plus_chance(num:int)
signal lower_cd(num:float)

var plus_spike_upgrades = 0
var plus_chance_upgrades = 0
var lower_cd_upgrades = 0

func _on_button_pressed() -> void:
	plus_spikes.emit(plus_spike_upgrades + 1)
	plus_chance_upgrades += 1
	screen.visible = false

func _on_button_2_pressed() -> void:
	plus_chance_upgrades.emit(plus_chance_upgrades + 10)
	plus_chance_upgrades += 10
	screen.visible = false

func _on_button_3_pressed() -> void:
	lower_cd.emit(lower_cd_upgrades + 0.25)
	lower_cd_upgrades += 0.5
	screen.visible = false
