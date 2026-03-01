extends Area2D
var attackspeed = 1
var can_attack = true
var damage = 3
var tentacles = 1

func attack_cd():
	await get_tree().create_timer(attackspeed).timeout
	can_attack = true

func _physics_process(delta: float) -> void:
	for body in get_overlapping_bodies():
		if can_attack && body is Enemy:
			body.take_damage_signal.emit(damage * tentacles)
			can_attack = false
			attack_cd()
