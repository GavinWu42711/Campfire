extends RigidBody2D

var has_dropped = false
var starty = 0
var random_scale = randf_range(2.0, 4.0)

func _ready():
	# Store starting Y as soon as the scene loads
	starty = global_position.y
	gravity_scale = 0   # keep it still until triggered
	$Trigger.scale = Vector2(random_scale, random_scale)
	$Sprite2D.scale = Vector2(random_scale, random_scale)

func _on_trigger_body_entered(body: Node2D) -> void:
	if body is Player and not has_dropped:
		$AnimatedSprite2D.show()
		$AnimatedSprite2D.modulate = Color(1, 1, 1, 0.5)
		gravity_scale = random_scale*1.5
		has_dropped = true
		await get_tree().create_timer(2.3).timeout
		self.queue_free()



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		var dist = get_fall_distance()
		body.take_damage_signal.emit(round(dist/100))
func get_fall_distance():
	return -global_position.y - starty
