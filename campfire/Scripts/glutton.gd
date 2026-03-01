extends Area2D

var attackspeed = 3
var can_attack = true
var damage = 15

func _physics_process(delta: float) -> void:
	for body in get_overlapping_bodies():
		if can_attack && body is Enemy:
			body.take_damage_signal.emit(damage)
			can_attack = false
			attack_cd()

func attack_cd():
	await get_tree().create_timer(attackspeed).timeout
	can_attack = true
