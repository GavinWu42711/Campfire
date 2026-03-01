extends Enemy

func _ready() -> void:
	super._ready()

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	
func die() -> void:
	SceneHandler.level_4_pass = true
	super.die()
