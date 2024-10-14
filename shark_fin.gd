extends RigidBody2D

@export var speed: float = 100.0 
var direction: Vector2

func _ready():
	# Set a random direction (left or right)
	var random_value = randf_range(-1, 1)
	if random_value < 0:
		direction = Vector2(-1, 0)
	else:
		direction = Vector2(1, 0)

	direction = direction.normalized()  # Normalize the direction just in case

func _process(delta: float):
	position += direction * speed * delta

	# Remove the shark if it goes off screen
	if position.x < -500 or position.x > 400:  # Adjust based on your screen width
		queue_free()
