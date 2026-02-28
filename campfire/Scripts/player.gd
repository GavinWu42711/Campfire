extends CharacterBody2D

class_name Player

signal take_damage_signal(damage:int)

func _ready() -> void:
	take_damage_signal.connect(take_damage)
	
func take_damage(damage:int):
	pass
	
func _physics_process(delta: float) -> void:
	pass
