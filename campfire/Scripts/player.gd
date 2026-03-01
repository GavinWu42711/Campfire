extends CharacterBody2D

class_name Player

@onready var spikes: Area2D = $Spikes
@onready var glutton: Area2D = $Glutton
@onready var tentacles: Area2D = $Tentacles
@onready var hp_bar: ProgressBar = $HpBar
@onready var upgrade_screen_spikes: Node2D = $UpgradeScreenSpikes
@onready var upgrade_tentacles: Node2D = $upgrade_tentacles
@onready var upgrade_glutton: Node2D = $upgrade_glutton
@onready var character_body_2d: Player = $"."

signal take_damage_signal(damage:int)
signal up_gluttons_bite()
signal up_tentacles()
signal up_spikes

var ms = 500
var click_pos = Vector2()
var target_pos = Vector2()
#var is_attacking = false
var is_dashing = false
var distance_travelled = 0
var dash_on_cd = false;
var dash_cd = 5;
var dash_range = 100;
var max_hp = 100
var vulnerable = true
var alive = true

func _ready() -> void:
	take_damage_signal.connect(take_damage)
	click_pos = position
	if Global.weapon == "glutton's bite":
		glutton.process_mode = Node.PROCESS_MODE_INHERIT
		glutton.visible = true
	elif Global.weapon == "tentacles":
		tentacles.process_mode = Node.PROCESS_MODE_INHERIT
		tentacles.visible = true
	elif Global.weapon == "spikes":
		spikes.process_mode = Node.PROCESS_MODE_INHERIT
		spikes.visible = true

func _on_selection_screen_choose_glutton_signal() -> void:
	glutton.process_mode = Node.PROCESS_MODE_INHERIT
	glutton.visible = true
	Global.weapon = "glutton's bite"
	glutton.scale *= Global.bite_range

func _on_selection_screen_choose_spikes_signal() -> void:
	spikes.process_mode = Node.PROCESS_MODE_INHERIT
	spikes.visible = true
	Global.weapon = "spikes"

func _on_selection_screen_choose_tentacles_signal() -> void:
	tentacles.process_mode = Node.PROCESS_MODE_INHERIT
	tentacles.visible = true
	Global.weapon = "tentacles"
	tentacles.scale *= Global.tent_range

func take_damage(damage:int):
	if vulnerable && alive:
		Global.hp -= damage
		hp_bar.value = Global.hp
		if Global.weapon == "glutton's bite":
			$AnimatedSprite2D.play("hurt")
		elif Global.weapon == "tentacles":
			pass
		else:
			$AnimatedSprite2D.play("spike_hurt")
		vulnerable = false
		vulnerability_cd()
	if Global.hp <= 0:
		Global.hp = 0
		die()

func die():
	if Global.weapon == "glutton's bite":
		$AnimatedSprite2D.play("death")
	elif Global.weapon == "tentacles":
		pass
	else:
		$AnimatedSprite2D.play("spike_death")
	await get_tree().create_timer(1).timeout
	reset()
	get_tree().change_scene_to_file("res://Scenes/defeat_screen.tscn")

func vulnerability_cd():
	await get_tree().create_timer(1).timeout
	vulnerable = true
	
func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("move"):
		if Global.weapon == "glutton's bite":
			$AnimatedSprite2D.play("swim")
		elif Global.weapon == "tentacles":
			pass
		else:
			$AnimatedSprite2D.play("spike_move")
		click_pos = get_global_mouse_position()
		is_dashing = false
		distance_travelled = 0

	if position.distance_to(click_pos) > 3 && is_dashing == false:
		target_pos = (click_pos - position).normalized()
		look_at(click_pos)
		velocity = target_pos * ms
		move_and_slide()
	else:
		velocity = Vector2.ZERO
		if Global.weapon == "glutton's bite":
			$AnimatedSprite2D.play("idle")
		elif Global.weapon == "tentacles":
			pass
		else:
			$AnimatedSprite2D.play("spike_idle")

	Global.player_pos = self.global_position
	
	if Input.is_action_just_pressed("dash"):
		dash()
	if is_dashing:
		if distance_travelled < dash_range:
			velocity = ms * 3 * (target_pos - position).normalized()
			move_and_slide()
			distance_travelled += (ms * delta * 3) / 2
		else:
			dash_start_cd()

func dash_start_cd():
	await get_tree().create_timer(dash_cd).timeout
	dash_on_cd = false

func dash():
	if dash_on_cd == false:
		target_pos = get_global_mouse_position()
		is_dashing = true
		dash_on_cd = true
		look_at(get_global_mouse_position())

func evolve():
	character_body_2d.scale *= 1.5
	Global.max_hp += 20
	Global.hp += 20
	if Global.weapon == "glutton's bite":
		up_gluttons_bite.emit()
		Global.bite_damage += 30
		Global.bite_attackspeed -= 0.2
		character_body_2d.scale *= Global.bite_range
	elif Global.weapon == "tentacles":
		up_tentacles.emit()
		Global.tent_damage += 5
		Global.tentacles += 1
		character_body_2d.scale *= Global.tent_range
	else:
		Global.spike_burst_unlocked = true
		up_spikes.emit()
		Global.spikes += 1
		Global.spike_damage += 4
		Global.spike_waves += 1

func reset():
	Global.max_hp = 100
	Global.hp = 100
	Global.spike_attackspeed = 1.5
	Global.spike_damage = 21
	Global.spikes = 1
	Global.spike_waves = 1
	Global.spike_burst_cd = 5
	Global.spikes_on_cd = false
	Global.shooting_spikes = false
	Global.spike_burst_unlocked = false
	Global.burst_chance = 0

	Global.tent_attackspeed = 1
	Global.tent_damage = 17
	Global.tentacles = 1
	Global.knockback_dist = 0.0
	Global.dot = 0
	Global.dot_duration = 0.0
	Global.tent_range = 1

	Global.bite_attackspeed = 3
	Global.bite_damage = 35
	Global.lifesteal = 0.0
	Global.bite_range = 1
