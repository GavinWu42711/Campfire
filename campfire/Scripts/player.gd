extends CharacterBody2D

class_name Player

signal take_damage_signal(damage:int)

var ms = 200
var click_pos = Vector2()
var target_pos = Vector2()
var is_attacking = false

func _ready() -> void:
	take_damage_signal.connect(take_damage)
	click_pos = position
	
func take_damage(damage:int):
	pass
	
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("move"):
		click_pos = get_global_mouse_position()
		is_attacking = false
		
	if position.distance_to(click_pos) > 3 && is_attacking == false:
		target_pos = (click_pos - position).normalized()
		look_at(click_pos)
		velocity = target_pos * ms
		move_and_slide()
	else:
		velocity = Vector2.ZERO
	
	Global.player_pos = self.transform.get_origin()
