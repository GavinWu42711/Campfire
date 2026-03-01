extends Area2D

@onready var glutton: Area2D = $"."
@onready var animated_sprite_2d: AnimatedSprite2D = $"../AnimatedSprite2D"

var can_attack = true

func _physics_process(delta: float) -> void:
	for body in get_overlapping_bodies():
		if can_attack && body is Enemy:
			body.take_damage_signal.emit(Global.bite_damage)
			Global.hp += Global.bite_damage * Global.lifesteal
			animated_sprite_2d.play("attack")
			can_attack = false
			attack_cd()

func attack_cd():
	await get_tree().create_timer(Global.bite_attackspeed).timeout
	can_attack = true
