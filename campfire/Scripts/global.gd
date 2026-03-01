extends Node

var player_pos:Vector2

var max_hp = 100
var hp = 100
var weapon:String

var spike_attackspeed = 1.5
var spike_damage = 5
var spikes = 3
var spike_waves = 1
var spike_burst_cd = 5
var spikes_on_cd = false
var shooting_spikes = false
var spike_burst_unlocked = false
var burst_chance = 0

var tent_attackspeed = 1
var tent_damage = 17
var tentacles = 1
var knockback_dist = 0.0
var dot = 0
var dot_duration = 0.0
var tent_range = 1

var bite_attackspeed = 2
var bite_damage = 50
var lifesteal = 0.10
var bite_range = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
