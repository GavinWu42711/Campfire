extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EnemySpawner.start_spawning_signal.emit(4)
	get_node("Player").evolve()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
