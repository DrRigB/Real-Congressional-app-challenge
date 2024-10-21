extends Node

@onready var coral: RigidBody2D = $Coral
@onready var walrus: RigidBody2D = $walrus
@onready var turtle: RigidBody2D = $turtle

var numbers_called = []  # List to keep track of called numbers

func _ready():
	# Initially set sprites to invisible and non-collidable
	coral.visible = false
	coral.collision_layer = 0  # Disable collision layer

	walrus.visible = false
	walrus.collision_layer = 0  # Disable collision layer

	turtle.visible = false
	turtle.collision_layer = 0  # Disable collision layer

	# Start the random number generator
	randomize()
	_generate_random_number()

func _generate_random_number() -> void:
	if numbers_called.size() < 3:
		var random_number = randi() % 3 + 1  # Generate a random number between 1 and 3
		if random_number not in numbers_called:
			numbers_called.append(random_number)
			_on_random_number_generated(random_number)

func _on_random_number_generated(random_number: int) -> void:
	match random_number:
		1:
			coral.visible = true
			coral.collision_layer = 1  # Enable collision layer
		2:
			walrus.visible = true
			walrus.collision_layer = 1  # Enable collision layer
		3:
			turtle.visible = true
			turtle.collision_layer = 1  # Enable collision layer

# Function to handle collision with the player
func _on_creature_collected(creature: RigidBody2D) -> void:
	creature.visible = false
	creature.collision_layer = 0  # Disable collision layer
