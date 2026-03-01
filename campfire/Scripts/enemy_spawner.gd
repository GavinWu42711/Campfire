extends Node

#Enemy scenes
var anglerfish_enemy:PackedScene = preload("res://Scenes/AnglerfishEnemy.tscn")
var eel_enemy:PackedScene = preload("res://Scenes/EelEnemy.tscn")
var jellyfish_enemy:PackedScene = preload("res://Scenes/JellyfishEnemy.tscn")
var octopus_enemy:PackedScene = preload("res://Scenes/OctopusEnemy.tscn")
var swordfish_enemy:PackedScene = preload("res://Scenes/SwordfishEnemy.tscn")
var turtle_enemy:PackedScene = preload("res://Scenes/TurtleEnemy.tscn")

#Compiled list of enemies
var enemy_list = [anglerfish_enemy, eel_enemy, jellyfish_enemy, octopus_enemy, swordfish_enemy, turtle_enemy]
enum ENEMY_ENUM {ANGLERFISH_ENEMY, EEL_ENEMY, JELLYFISH_ENEMY, OCTOPUS_ENEMY, SWORDFISH_ENEMY, TURTLE_ENEMY}
var depth_1_enemy = [ENEMY_ENUM.EEL_ENEMY]
var depth_2_enemy = [ENEMY_ENUM.EEL_ENEMY]
var depth_3_enemy = [ENEMY_ENUM.EEL_ENEMY]
var depth_4_enemy = [ENEMY_ENUM.EEL_ENEMY]

#To determine what and when to spawn
var spawn_handler_on:bool = false
var depth:int = 0
var spawner_cooldown:float = 10 #How long before another wave of enemies should be spawn
var spawn_next_wave:bool = false

#Emit to start spawning
signal start_spawning_signal(depth:int)

#Emit to stop spawning
signal stop_spawning_signal()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_spawning_signal.connect(start_spawner)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	spawn_handler()

func start_spawner(depth:int) -> void:
	spawn_handler_on = true
	spawn_next_wave = true
	depth = depth
	
func stop_spawner() -> void:
	spawn_handler_on = false

func spawn_handler() -> void:
	if spawn_next_wave:
		spawn_next_wave = false
		if depth == 0:
			spawn_handler_on = false
		elif depth == 1:
			spawn_depth_1_wave()
		elif depth == 2:
			spawn_depth_2_wave()
		elif depth == 3:
			spawn_depth_3_wave()
		elif depth == 4:
			spawn_depth_4_wave()
			
	
func start_spawner_countdown() -> void:
	await get_tree().create_timer(spawner_cooldown).timeout
	spawn_next_wave = true	

#Spawns the enemy based in the enemy enum provided
#Position of the enemy is randomized based on the player, with the range being relative to max and min distance
func spawn_enemy(enemy_enum_int:int, max_distance:int = 1200, min_distance:int = 1000) -> void:
	#Spawn the enemy
	var enemy_scene:PackedScene = enemy_list[enemy_enum_int]
	var enemy:Enemy = enemy_scene.instantiate()
	
	#Randomize where the enemy is using a random spot on a circle with a random radius
	var player_global_pos:Vector2 = Global.player_pos
	var theta:int = randi_range(0,360)
	var radius:int = randi_range(min_distance,max_distance)
	var enemy_offset:Vector2 = (Vector2.UP * radius).rotated(deg_to_rad(theta))
	
	#Apply the offset relative to the player pos
	enemy.global_position = player_global_pos + enemy_offset

#Spawns 10 random enemies from depth 1 list
func spawn_depth_1_wave() -> void:
	for i in range(10):
		spawn_enemy(depth_1_enemy.pick_random())

#Spawns 10 random enemies from depth 2 list
func spawn_depth_2_wave() -> void:
	for i in range(10):
		spawn_enemy(depth_2_enemy.pick_random())

#Spawns 10 random enemies from depth 3 list
func spawn_depth_3_wave() -> void:
	for i in range(10):
		spawn_enemy(depth_3_enemy.pick_random())

#Spawns 10 random enemies from depth 4 list
func spawn_depth_4_wave() -> void:
	for i in range(10):
		spawn_enemy(depth_4_enemy.pick_random())


	
	
