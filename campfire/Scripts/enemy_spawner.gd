extends Node

#Enemy scenes
var anglerfish_enemy:PackedScene = preload("res://Scenes/AnglerfishEnemy.tscn")
var eel_enemy:PackedScene = preload("res://Scenes/EelEnemy.tscn")
var jellyfish_enemy:PackedScene = preload("res://Scenes/JellyfishEnemy.tscn")
var octopus_enemy:PackedScene = preload("res://Scenes/OctopusEnemy.tscn")
var swordfish_enemy:PackedScene = preload("res://Scenes/SwordfishEnemy.tscn")
var turtle_enemy:PackedScene = preload("res://Scenes/TurtleEnemy.tscn")
var alligator_enemy:PackedScene = preload("res://Scenes/AlligatorEnemy.tscn")
var blue_fish_enemy:PackedScene = preload("res://Scenes/BlueFishEnemy.tscn")
var green_fish_enemy:PackedScene = preload("res://Scenes/GreenFishEnemy.tscn")
var mermaid_staff_enemy:PackedScene = preload("res://Scenes/MermaidStaffEnemy.tscn")
var mermaid_sword_enemy:PackedScene = preload("res://Scenes/MermaidSwordEnemy.tscn")
var orca_enemy:PackedScene = preload("res://Scenes/OrcaEnemy.tscn")
var shark_enemy:PackedScene = preload("res://Scenes/SharkEnemy.tscn")

#Compiled list of enemies
var enemy_list = [anglerfish_enemy,
					eel_enemy, 
					jellyfish_enemy, 
					octopus_enemy, 
					swordfish_enemy, 
					turtle_enemy,
					alligator_enemy, 
					blue_fish_enemy, 
					green_fish_enemy,  
					mermaid_staff_enemy,  
					mermaid_sword_enemy,  
					orca_enemy, 
					shark_enemy]
					
enum ENEMY_ENUM {ANGLERFISH_ENEMY, #3
						EEL_ENEMY, #3
						JELLYFISH_ENEMY, #1
						OCTOPUS_ENEMY, #2
						SWORDFISH_ENEMY, #2
						TURTLE_ENEMY,#1
						ALLIGATOR_ENEMY, #3
						BLUE_FISH_ENEMY, #1
						GREEN_FISH_ENEMY, #1
						MERMAID_STAFF_ENEMY, #3
						MERMAID_SWORD_ENEMY, #3
						ORCA_ENEMY, #2 
						SHARK_ENEMY} #2
						
var depth_1_enemy = [ENEMY_ENUM.BLUE_FISH_ENEMY,
					ENEMY_ENUM.GREEN_FISH_ENEMY,
					ENEMY_ENUM.TURTLE_ENEMY, 
					ENEMY_ENUM.JELLYFISH_ENEMY]
var depth_2_enemy = [ENEMY_ENUM.SWORDFISH_ENEMY,
					ENEMY_ENUM.ORCA_ENEMY,
					ENEMY_ENUM.SHARK_ENEMY]
var depth_3_enemy = [ENEMY_ENUM.EEL_ENEMY, 
					ENEMY_ENUM.ANGLERFISH_ENEMY, 
					ENEMY_ENUM.ALLIGATOR_ENEMY, 
					ENEMY_ENUM.MERMAID_STAFF_ENEMY, 
					ENEMY_ENUM.MERMAID_SWORD_ENEMY]
var depth_4_enemy = []

#To determine what and when to spawn
var spawn_handler_on:bool = false
var depth:int = 0
var spawner_cooldown:float = 10 #How long before another wave of enemies should be spawn
var spawn_next_wave:bool = true


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

func start_spawner(var_depth:int) -> void:
	spawn_handler_on = true
	spawn_next_wave = true
	depth = var_depth
	
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
func spawn_enemy(enemy_enum_int:int, enemy_depth:int = 0, max_distance:int = 1200, min_distance:int = 1000) -> void:
	#Spawn the enemy
	var enemy_scene:PackedScene = enemy_list[enemy_enum_int]
	var enemy:Enemy = enemy_scene.instantiate()
	enemy.enemy_depth = enemy_depth
	
	#Randomize where the enemy is using a random spot on a circle with a random radius
	var player_global_pos:Vector2 = Global.player_pos
	var theta:int = randi_range(0,360)
	var radius:int = randi_range(min_distance,max_distance)
	var enemy_offset:Vector2 = (Vector2.UP * radius).rotated(deg_to_rad(theta))
	
	#Apply the offset relative to the player pos
	enemy.global_position = player_global_pos + enemy_offset
	
	#Find the level node
	var level_node:Node2D
	
	while level_node == null:
		for child in get_tree().root.get_children():
			if child is Node2D:
				level_node = child
				break
	
	#Add enemy as child
	level_node.add_child(enemy)

#Spawns 10 random enemies from depth 1 list
func spawn_depth_1_wave() -> void:
	for i in range(15):
		spawn_enemy(depth_1_enemy.pick_random(), 1)

#Spawns 10 random enemies from depth 2 list
func spawn_depth_2_wave() -> void:
	for i in range(15):
		spawn_enemy(depth_2_enemy.pick_random(), 2)

#Spawns 10 random enemies from depth 3 list
func spawn_depth_3_wave() -> void:
	for i in range(15):
		spawn_enemy(depth_3_enemy.pick_random(), 3)

#Spawns 10 random enemies from depth 4 list
func spawn_depth_4_wave() -> void:
	for i in range(15):
		spawn_enemy(depth_4_enemy.pick_random(), 4)


	
	
