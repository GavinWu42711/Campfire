extends CharacterBody2D

class_name Player

@onready var spikes: Area2D = $Spikes
@onready var glutton: Area2D = $Glutton
@onready var tentacles: Area2D = $Tentacles
@onready var hp_bar: ProgressBar = $HpBar
@onready var button: Button = $CanvasLayer/ColorRect/Button
@onready var button_2: Button = $CanvasLayer/ColorRect/Button2
@onready var button_3: Button = $CanvasLayer/ColorRect/Button3
@onready var start_selection: ColorRect = $CanvasLayer/ColorRect

signal take_damage_signal(damage:int)

var ms = 200
var click_pos = Vector2()
var target_pos = Vector2()
#var is_attacking = false
var is_dashing = false
var distance_travelled = 0
var dash_on_cd = false;
var dash_cd = 5;
var dash_range = 100;
var hp = 100
var max_hp = 100
var vulnerable = true
var alive = true

func _ready() -> void:
	take_damage_signal.connect(take_damage)
	click_pos = position
	get_tree().paused = true

func take_damage(damage:int):
	print("supposed to take damage")
	if vulnerable && alive:
		hp -= damage
		hp_bar.value = hp
		vulnerable = false
		vulnerability_cd()
	if hp <= 0:
		hp = 0
		die()

func die():
	queue_free()

func vulnerability_cd():
	await get_tree().create_timer(1).timeout
	vulnerable = true
	
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("move"):
		click_pos = get_global_mouse_position()
		#is_attacking = false
		is_dashing = false
		distance_travelled = 0

		
	if position.distance_to(click_pos) > 3 && is_dashing == false:
		target_pos = (click_pos - position).normalized()
		look_at(click_pos)
		velocity = target_pos * ms
		move_and_slide()
	else:
		velocity = Vector2.ZERO

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


func _on_button_pressed() -> void:
	spikes.process_mode = Node.PROCESS_MODE_INHERIT
	spikes.visible = true
	start_selection.visible = false
	get_tree().paused = false

func _on_button_2_pressed() -> void:
	glutton.process_mode = Node.PROCESS_MODE_INHERIT
	glutton.visible = true
	start_selection.visible = false
	get_tree().paused = false

func _on_button_3_pressed() -> void:
	tentacles.process_mode = Node.PROCESS_MODE_INHERIT
	tentacles.visible = true
	start_selection.visible = false
	get_tree().paused = false
