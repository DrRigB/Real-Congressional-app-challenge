extends RigidBody2D

var speed = 20
var imp = 0

func _ready() -> void:
	apply_impulse(Vector2(), Vector2(randf_range(-imp,imp),randf_range(-imp,imp)))
	
func _process(delta: float) -> void:
	position.y += speed * delta
