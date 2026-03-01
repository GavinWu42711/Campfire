extends Area2D

@onready var player: Player = $".."
@onready var tentacles_wpn: Area2D = $"."
@onready var animated_sprite_2d: AnimatedSprite2D = $"../AnimatedSprite2D"

var attackspeed = 1
var can_attack = true

func attack_cd():
	await get_tree().create_timer(attackspeed).timeout
	can_attack = true

func _physics_process(delta: float) -> void:
	for body in get_overlapping_bodies():
		if can_attack && body is Enemy:
			body.take_damage_signal.emit(Global.tent_damage * Global.tentacles)
			body.apply_knockback.emit(player.rotation, Global.knockback_dist)
			body.take_dot.emit(Global.dot, Global.dot_duration)
			if Global.weapon == "glutton's bite":
				animated_sprite_2d.play("attack")
			elif Global.weapon == "tentacles":
				pass
			else:
				animated_sprite_2d.play("spike_attack")
	can_attack = false
	attack_cd()
