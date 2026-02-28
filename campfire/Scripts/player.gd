extends CharacterBody2D

class_name Player

signal take_damage_signal(damage:int)

var ms = 200
var click_pos = Vector2()
var target_pos = Vector2()
var is_attacking = false
var is_dashing = false
var distance_travelled = 0
var dash_on_cd = false;
var dash_cd = 0;
var dash_range = 100;

func _ready() -> void:
	take_damage_signal.connect(take_damage)
	click_pos = position
	
func take_damage(damage:int):
	pass
	
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("move"):
		click_pos = get_global_mouse_position()
		is_attacking = false
		is_dashing = false
		distance_travelled = 0
		
	if position.distance_to(click_pos) > 3 && is_attacking == false && is_dashing == false:
		target_pos = (click_pos - position).normalized()
		look_at(click_pos)
		velocity = target_pos * ms
		move_and_slide()
	else:
		velocity = Vector2.ZERO


	Global.player_pos = self.transform.get_origin()

	if Input.is_action_just_pressed("dash"):
		dash()
	if is_dashing:
		if distance_travelled < dash_range:
			velocity = ms * 3 * (target_pos - position).normalized()
			move_and_slide()
			distance_travelled += (ms * delta * 1.5) / 2
		else:
			await get_tree().create_timer(dash_cd).timeout
			dash_on_cd = false
	else:
		await get_tree().create_timer(dash_cd).timeout
		dash_on_cd = false
	
func dash():
	if dash_on_cd == false:
		target_pos = get_global_mouse_position()
		is_dashing = true
		dash_on_cd = true
		look_at(get_global_mouse_position())
