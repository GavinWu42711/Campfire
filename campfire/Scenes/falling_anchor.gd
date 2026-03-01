extends CharacterBody2D

@export var fallSpeed := 500.0

var falling := false
var hasFallen := false

func _physics_process(delta):
	if falling:
		velocity.y = fallSpeed
	else:
		velocity.y = 0
	
	move_and_slide()
	velocity.y*=1.1


func _on_trigger_body_entered(body: Node2D) -> void:
	if body is Player and not hasFallen:
		falling = true
		hasFallen = true
