extends CharacterBody2D

@onready var dormant = true
@onready var random_scale

func _ready():
	$AnimatedSprite2D.play("Dormant")
	random_scale = randf_range(2.5, 7.5)#size range
	scale = Vector2(random_scale, random_scale)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		body.take_damage_signal.emit(4*random_scale)
		$AnimatedSprite2D.play("Explode")
		dormant = false
		await get_tree().create_timer(1).timeout
		self.queue_free()
