extends Area2D

var attackspeed = 3
var can_attack = true
var damage = 15

func _on_area_entered(body) -> void:
	if can_attack && body is Enemy:
		for i in get_overlapping_bodies():
			body.take_damage_signal.emit(damage)
	can_attack = false
	attack_cd()

func attack_cd():
	await get_tree().create_timer(attackspeed).timeout
	can_attack = true
