extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !SceneHandler.level_2_loaded:
		get_node("Player").evolve()
		SceneHandler.level_2_loaded = true
	EnemySpawner.start_spawning_signal.emit(2)
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
