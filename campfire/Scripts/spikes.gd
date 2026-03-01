extends Area2D

@onready var spikes_area: Area2D = $"."
@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"

var can_attack = true
var shooting_spikes = false
var chance = 0

func attack_cd():
	await get_tree().create_timer(Global.spike_attackspeed).timeout
	can_attack = true

func _physics_process(delta: float) -> void:
	for body in get_overlapping_bodies():
		if can_attack && body is Enemy:
			body.take_damage_signal.emit(Global.spike_damage * Global.spikes)
			animation_player.play("attack")
			can_attack = false
			attack_cd()
	if !Global.spikes_on_cd && Global.spike_burst_unlocked:
		spike_burst()
		Global.spikes_on_cd = true

func start_cd():
	await get_tree().create_timer(Global.spike_burst_cd).timeout
	Global.spikes_on_cd = false

func spike_burst():
	shooting_spikes = true
	if Global.spikes_on_cd == false:
		Global.spikes_on_cd = true
		for z in Global.spike_waves:
			for i in Global.spikes:
				var bullet = preload("res://Scenes/spike_proj.tscn")
				var new_bullet = bullet.instantiate()
				var angle = (2 * PI / Global.spikes) * i
				new_bullet.position = %SpawnPoint.position 
				new_bullet.global_rotation = %SpawnPoint.global_rotation + angle
				%SpawnPoint.add_child(new_bullet)
			await get_tree().create_timer(0.5).timeout
		await get_tree().create_timer(1).timeout
		shooting_spikes = false
		await get_tree().create_timer(Global.spike_burst_cd).timeout
		Global.spikes_on_cd = false

func _on_character_body_2d_take_damage_signal(damage: int) -> void:
	chance = randi_range(1, 100)
	if chance <= Global.burst_chance:
		spike_burst()
