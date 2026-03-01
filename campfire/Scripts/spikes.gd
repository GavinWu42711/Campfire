extends Area2D

@onready var spikes_area: Area2D = $"."

var attackspeed = 1.5
var can_attack = true
var damage = 5
var spikes = 10
var spike_rounds = 1
var spike_burst_cd = 5
var spikes_on_cd = false
var shooting_spikes = false
var spike_burst_unlocked = true
var burst_chance = 0
var chance = 0

func attack_cd():
	await get_tree().create_timer(attackspeed).timeout
	can_attack = true

func _physics_process(delta: float) -> void:
	for body in get_overlapping_bodies():
		if can_attack && body is Enemy:
			body.take_damage_signal.emit(damage * spikes)
			can_attack = false
			attack_cd()
	if !spikes_on_cd && spike_burst_unlocked:
		spike_burst()
		spikes_on_cd = true

func start_cd():
	await get_tree().create_timer(spike_burst_cd).timeout
	spikes_on_cd = false

func spike_burst():
	shooting_spikes = true
	if spikes_on_cd == false:
		spikes_on_cd = true
		for z in spike_rounds:
			for i in spikes:
				var bullet = preload("res://Scenes/spike_proj.tscn")
				var new_bullet = bullet.instantiate()
				var angle = (2 * PI / spikes) * i
				new_bullet.position = %SpawnPoint.position 
				new_bullet.global_rotation = %SpawnPoint.global_rotation + angle
				%SpawnPoint.add_child(new_bullet)
			await get_tree().create_timer(0.5).timeout
		await get_tree().create_timer(1).timeout
		shooting_spikes = false
		await get_tree().create_timer(spike_burst_cd).timeout
		spikes_on_cd = false

func _on_upgrade_screen_spikes_lower_cd(num: float) -> void:
	spike_burst_cd -= num

func _on_upgrade_screen_spikes_plus_chance(num: int) -> void:
	burst_chance += num

func _on_upgrade_screen_spikes_plus_spikes(num: int) -> void:
	spikes += num

func _on_character_body_2d_take_damage_signal(damage: int) -> void:
	chance = randi_range(1, 100)
	if chance <= burst_chance:
		spike_burst()
