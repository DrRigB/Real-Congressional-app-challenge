extends RigidBody2D

@onready var player: CharacterBody2D = $"../../player"

func _ready():
	# Connect the body_entered signal to the RigidBody2D
	self.connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	if body == player:  # Check if the colliding body is the player
		queue_free()  # Remove the creature from the scene upon collision
