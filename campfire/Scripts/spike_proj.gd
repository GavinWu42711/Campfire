extends Area2D

var speed = 1000
var distance_travelled = 0
var range = 1200
var damage = 5
var pierce = 1
var bodies_hit = 0


func _physics_process(delta: float) -> void:
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * speed * delta
	distance_travelled += speed * delta
	if distance_travelled > range:
		queue_free()

func _on_body_entered(body):
	if body is Enemy:
		body.take_damage_signal.emit(damage)
		bodies_hit += 1
	if bodies_hit == pierce:
		queue_free()
