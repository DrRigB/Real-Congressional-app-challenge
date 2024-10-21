extends CharacterBody2D

const SPEED = 150.0
const ACCEL = 2.0

var input: Vector2 = Vector2.ZERO  # Initialize the input vector

func get_input():
	input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	return input.normalized()

func _process(delta):
	var player_input = get_input()

	velocity = velocity.lerp(player_input * SPEED, delta * ACCEL)  # Ensure `delta` is used correctly
	move_and_slide()
