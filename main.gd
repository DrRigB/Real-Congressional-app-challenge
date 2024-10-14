extends Node2D

var TrashBagScene = preload("res://TrashBag.tscn")
var GameOverMenuScene = preload("res://GameOverMenu.tscn")
var rng = RandomNumberGenerator.new()

@onready var spawn_timer: Timer = $SpawnTimer  # Reference to the spawn Timer node
@onready var game_over_timer: Timer = $GameOverTimer  # Reference to the game over Timer node
@onready var shark_animation_timer: Timer = $SharkAnimationTimer  # Reference to the Shark Animation Timer

@onready var shark_fin_animation: AnimationPlayer = $Shark/SharkFin/AnimationPlayer
@onready var shark_fin_2_animation: AnimationPlayer = $Shark/SharkFin2/AnimationPlayer
@onready var shark_fin_3_animation: AnimationPlayer = $Shark/SharkFin3/AnimationPlayer

var spawn_count = 0
var max_spawns = rng.randf_range(50, 100)
var game_over_shown = false  # Flag to check if the game over menu is displayed

func _ready():
	rng.randomize()
	print("Starting to create TrashBag instances")

	spawn_timer.wait_time = 0.5
	spawn_timer.start()

	# Set a random wait time for the Shark Animation Timer between 10 and 30 seconds
	shark_animation_timer.wait_time = rng.randf_range(10, 30)
	print("Shark animation timer started with wait time: ", shark_animation_timer.wait_time)
	shark_animation_timer.start()

	# Connect signals for timers
	if not spawn_timer.is_connected("timeout", Callable(self, "_on_spawn_timer_timeout")):
		spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	if not shark_animation_timer.is_connected("timeout", Callable(self, "_on_shark_animation_timeout")):
		shark_animation_timer.timeout.connect(_on_shark_animation_timeout)
	if not game_over_timer.is_connected("timeout", Callable(self, "_on_game_over_timer_timeout")):
		game_over_timer.timeout.connect(_on_game_over_timer_timeout)

func _on_spawn_timer_timeout() -> void:
	if spawn_count < max_spawns:
		var trash = TrashBagScene.instantiate()
		var rand_x = rng.randf_range(-300, 300)
		var rand_y = rng.randf_range(-300, -100)
		trash.position = Vector2(rand_x, rand_y)
		add_child(trash)
		spawn_count += 1
		print("Added TrashBag instance at: ", trash.position)

		# Set random time between 1-5 seconds for the next spawn
		spawn_timer.wait_time = rng.randf_range(1, 5)
		spawn_timer.start()
	else:
		spawn_timer.stop()
		print("Finished creating TrashBag instances")

		# Start the game over timer (30 seconds delay)
		game_over_timer.wait_time = 30.0
		game_over_timer.start()

func _on_shark_animation_timeout() -> void:
	print("Playing shark fins animations")
	# Play the animations for the shark fins
	shark_fin_animation.play("shark_fin")  # Replace with actual animation names
	shark_fin_2_animation.play("shark_fin2")  # Replace with actual animation names
	shark_fin_3_animation.play("shark_fin3")  # Replace with actual animation names

	# Restart the Shark Animation Timer after the animation plays
	shark_animation_timer.wait_time = rng.randf_range(10, 30)  # Reset to a new random time
	shark_animation_timer.start()

func _on_game_over_timer_timeout() -> void:
	if game_over_shown:  # Check if the game over menu has already been shown
		return

	print("Game Over Timer triggered")
	game_over_shown = true  # Set the flag to true to prevent further calls

	var game_over_menu_instance = GameOverMenuScene.instantiate()
	if game_over_menu_instance != null:
		print("GameOverMenu instance created, adding to scene.")
		add_child(game_over_menu_instance)
	else:
		print("Error: Failed to instantiate GameOverMenu.")
