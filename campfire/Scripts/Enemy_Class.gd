extends CharacterBody2D

#Variables to be set 
@export var speed:float = 300.0
@export var enemy_attack_damage:int = 10
@export var max_health:int = 100
@export var enemy_hitbox:Area2D
@export var enemy_attack_hitbox:Area2D
@export var i_frame_length:float = 1 # in seconds

#Variables not to be set
var current_health:int
var can_take_damage:bool = true
var alive:bool = true

#Signal for the enemy to take damage; helps with decoupling
signal take_damage_signal(damage:int)

#Run once when the enemy is first instantiated
func _ready() -> void:
	current_health = max_health
	take_damage_signal.connect(take_damage)

#Run every second
func _physics_process(delta: float) -> void:

	move_and_slide()

#Makes the enemy take damage
func take_damage(damage:int):
	if can_take_damage and alive:
		#Start i-frame
		can_take_damage = false
		
		#Start i-frame cooldown
		take_damage_cooldown(i_frame_length)
		
		#Apply damage
		current_health -= damage
		
		if current_health <= 0:
			current_health = 0
			alive = false
			die()
		
#Starts a timer to allow the enemy to take damage again
func take_damage_cooldown(cooldown_length) -> void:
	await get_tree().create_timer(cooldown_length).timeout
	can_take_damage = true

#When the enemy dies
func die() -> void:
	pass
	
#Checks if any player hitboxes are in range
func check_attack_hitbox() -> void:
	for body in enemy_attack_hitbox.get_overlapping_bodies():
		if body is Player:
			attack(enemy_attack_damage,body.take_damage_signal)

#Deals damage to the player
func attack(attack_damage:int,hitbox_signal:Signal) -> void:
	hitbox_signal.emit(attack_damage)
	
