extends Area2D

var attackspeed = 1
var can_attack = true
var damage = 7

func _on_area_entered(enemy) -> void:
	if can_attack:
		enemy.take_damage_signal.emit(enemy)
	can_attack = false
	attack_cd()

func attack_cd():
	await get_tree().create_timer(attackspeed).timeout
	can_attack = true
