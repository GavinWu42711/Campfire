extends Area2D

@onready var glutton: Area2D = $"."

signal lifesteal_hp(num:float)

var attackspeed = 3
var can_attack = true
var damage = 15
var lifesteal = 0.0

func _physics_process(delta: float) -> void:
	for body in get_overlapping_bodies():
		if can_attack && body is Enemy:
			body.take_damage_signal.emit(damage)
			lifesteal_hp.emit(damage * lifesteal)
			can_attack = false
			attack_cd()

func attack_cd():
	await get_tree().create_timer(attackspeed).timeout
	can_attack = true

func _on_upgrade_glutton_plus_dmg(num: int) -> void:
	damage += num

func _on_upgrade_glutton_plus_lifesteal(num: float) -> void:
	lifesteal += num

func _on_upgrade_glutton_plus_range(num: float) -> void:
	glutton.scale *= num

func _on_character_body_2d_up_gluttons_bite() -> void:
	damage += 10
	attackspeed -= 0.2
