extends Area2D
var attackspeed = 1
var can_attack = true
var damage = 3
var tentacles = 1

func _on_area_entered(body) -> void:
	if can_attack && body is Enemy:
		for i in get_overlapping_bodies():
			for j in tentacles:
				await get_tree().create_timer(0.2).timeout
				body.take_damage_signal.emit(damage)
	can_attack = false
	attack_cd()

func attack_cd():
	await get_tree().create_timer(attackspeed).timeout
	can_attack = true
