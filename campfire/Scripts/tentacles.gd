extends Area2D

@onready var player: Player = $".."
@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"

var attackspeed = 1
var can_attack = true
var damage = 5
var tentacles = 1
var knockback_dist = 150.0
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
