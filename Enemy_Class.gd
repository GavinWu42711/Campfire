extends CharacterBody2D

class_name Enemy

@export var speed = 300.0
@export var damage = 1


func _physics_process(delta: float) -> void:

	move_and_slide()
