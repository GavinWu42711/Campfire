extends CharacterBody2D

@onready var timer = $RandomTimer

@onready var dormant = true

func _ready():
	start_random_timer()
	$AnimatedSprite2D.play("Dormant")

func start_random_timer():
	var random_time = randf_range(1.0, 6.0) #random wait time
	timer.wait_time = random_time
	timer.start()
func _on_random_timer_timeout():
	
	$AnimatedSprite2D.play("Explode")
	dormant = false
	await get_tree().create_timer(1).timeout
	dormant = true
	start_random_timer() #restart with new random time
	$AnimatedSprite2D.play("Dormant")




func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		body.take_damage_signal.emit(10)
