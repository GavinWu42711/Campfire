extends Node

#Scenes to instantiate/switch to
var player_scene:PackedScene = preload("res://Scenes/Player.tscn")
var level_1_scene:PackedScene = preload("res://Scenes/level_1.tscn")
var level_2_scene:PackedScene = preload("res://Scenes/level_2.tscn")
var level_3_scene:PackedScene = preload("res://Scenes/level_3.tscn")
var level_4_scene:PackedScene = preload("res://Scenes/level_4.tscn")

#Clear cons to switch scenes
var level_1_killed_goal = 10
var level_1_enemies_killed = 0
var level_2_killed_goal = 10
var level_2_enemies_killed = 0
var level_3_killed_goal = 10
var level_3_enemies_killed = 0
var level_4_pass = false

var level_1_loaded = false
var level_2_loaded = false
var level_3_loaded = false
var level_4_loaded = false


enum LEVEL {MENU, LEVEL_1, LEVEL_2, LEVEL_3, LEVEL_4, RESTART}
var current_level:int = LEVEL.MENU

#Signal to update clear cons
signal update_goals_signal(enemy_depth:int)

#Signal to reset clear cons
signal reset_clear_cons_signal() 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_goals_signal.connect(update_goals)
	reset_clear_cons_signal.connect(reset_clear_cons)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	check_goals()

func reset_clear_cons() -> void:
	level_1_enemies_killed = 0
	level_2_enemies_killed = 0
	level_3_enemies_killed = 0
	level_4_pass = false
	
func update_goals(enemy_depth:int = 0) -> void:
	if enemy_depth == 0:
		pass
	elif enemy_depth == 1:
		level_1_enemies_killed += 1
	elif enemy_depth == 2:
		level_2_enemies_killed += 1
	elif enemy_depth == 3:
		level_3_enemies_killed += 1
	elif enemy_depth == 4:
		level_4_pass = true
	
func check_goals() -> void:
	if current_level == LEVEL.MENU:
		#transition_scene(LEVEL.LEVEL_1)
		pass
	elif current_level == LEVEL.LEVEL_1:
		if level_1_enemies_killed >= level_1_killed_goal:
			transition_scene(LEVEL.LEVEL_2)
	elif current_level == LEVEL.LEVEL_2:
		if level_2_enemies_killed >= level_2_killed_goal:
			transition_scene(LEVEL.LEVEL_3)
	elif current_level == LEVEL.LEVEL_3:
		if level_3_enemies_killed >= level_3_killed_goal:
			transition_scene(LEVEL.LEVEL_4)
	elif current_level == LEVEL.LEVEL_4:
		if level_4_pass:
			transition_scene(LEVEL.RESTART)

func transition_scene(new_level:int) -> void:
	if new_level == LEVEL.MENU:
		current_level = LEVEL.MENU
		reset_clear_cons()
	elif new_level == LEVEL.LEVEL_1:
		get_tree().change_scene_to_packed(level_1_scene)
		current_level = LEVEL.LEVEL_1
	elif new_level == LEVEL.LEVEL_2:
		get_tree().change_scene_to_packed(level_2_scene)
		current_level = LEVEL.LEVEL_2
	elif new_level == LEVEL.LEVEL_3:
		get_tree().change_scene_to_packed(level_3_scene)
		current_level = LEVEL.LEVEL_3
	elif new_level == LEVEL.LEVEL_4:
		get_tree().change_scene_to_packed(level_4_scene)
		current_level = LEVEL.LEVEL_4
	elif new_level == LEVEL.RESTART:
		current_level = LEVEL.RESTART
		reset_clear_cons()
		
