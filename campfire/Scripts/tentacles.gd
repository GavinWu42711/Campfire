extends Area2D

signal apply_knockback(direction:float, units:float)
signal take_dot(damage:int, duration:float)

@onready var player: Player = $".."

var attackspeed = 1
var can_attack = true
var damage = 5
var tentacles = 1
var knockback_dist = 0.0
var dot = 0
var dot_duration = 0.0

@onready var tentacles_wpn: Area2D = $"."

func attack_cd():
	await get_tree().create_timer(attackspeed).timeout
	can_attack = true

func _physics_process(delta: float) -> void:
	for body in get_overlapping_bodies():
		if can_attack && body is Enemy:
			body.take_damage_signal.emit(damage * tentacles)
			body.apply_knockback.emit(player.rotation, knockback_dist)
			body.take_dot.emit(dot, dot_duration)
			can_attack = false
			attack_cd()

func _on_upgrade_tentacles_plus_dot(num: int, time: float) -> void:
	dot += num
	dot_duration += time
	
func _on_upgrade_tentacles_plus_knockback(num: int) -> void:
	knockback_dist += num

func _on_upgrade_tentacles_plus_range(num: float) -> void:
	tentacles_wpn.scale *= num

func _on_character_body_2d_up_tentacles() -> void:
	damage += 7
	tentacles += 1
