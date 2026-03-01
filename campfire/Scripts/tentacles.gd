extends Area2D
var attackspeed = 1
var can_attack = true
var damage = 3
var tentacles = 1
var bodies = 0
var attacking = false
@onready var tentacle_area: Area2D = $"."

func _physics_process(delta: float) -> void:
	pass

func attack_cd():
	await get_tree().create_timer(attackspeed).timeout
	can_attack = true

func _on_body_entered(body: Node2D) -> void:
	attacking = true
	print("body entered")
	print(can_attack)
	if can_attack && body is Enemy:
		print("body detected")
		while(attacking):
			print("attacking")
			for i in get_overlapping_bodies():
				for j in tentacles:
					body.take_damage_signal.emit(damage)
					await get_tree().create_timer(0.2).timeout
					print("dealing damage")
			bodies = tentacle_area.get_overlapping_bodies()
			if bodies.size() == 1:
				attacking = false
			print(bodies.size())
	can_attack = false
	attack_cd()
