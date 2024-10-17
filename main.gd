extends Node2D

var TrashBagScene = preload("res://TrashBag.tscn")
var GameOverMenuScene = preload("res://GameOverMenu.tscn")
var rng = RandomNumberGenerator.new()

@onready var spawn_timer: Timer = $SpawnTimer
@onready var game_over_timer: Timer = $GameOverTimer
@onready var shark_animation_timer: Timer = $SharkAnimationTimer

@onready var shark_fin_animation: AnimationPlayer = $Shark/SharkFin/AnimationPlayer
@onready var shark_fin_2_animation: AnimationPlayer = $Shark/SharkFin2/AnimationPlayer
@onready var shark_fin_3_animation: AnimationPlayer = $Shark/SharkFin3/AnimationPlayer

@onready var swim: AnimationPlayer = $fishy/swim
@onready var fishy: Node2D = $fishy  # Reference to the fish node for z-index control

var spawn_count = 0
var max_spawns = rng.randf_range(50, 100)
var game_over_shown = false

func _ready():
	rng.randomize()
	print("Starting to create TrashBag instances")

	spawn_timer.wait_time = 0.5
	spawn_timer.start()

	# Set random wait time for Shark Animation Timer between 10 and 30 seconds
	shark_animation_timer.wait_time = rng.randf_range(10, 30)
	print("Shark animation timer started with wait time: ", shark_animation_timer.wait_time)
	shark_animation_timer.start()

	# Ensure the fish appears on top of the sharks
	fishy.z_index = 2  # Set a higher z-index than sharks

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
	# Play the fish animation 2 seconds before the sharks
	print("Playing fish animation 2 seconds before the sharks")
	swim.play("swim")  # Trigger the fish animation
	
	# Delay the shark animations by 2 seconds to ensure the fish shows up first
	var shark_timer = get_tree().create_timer(2.0)  # Create a delay of 2 seconds
	shark_timer.timeout.connect(func() -> void:
		print("Playing shark fins animations")
		shark_fin_animation.play("shark_fin")
		shark_fin_2_animation.play("shark_fin2")
		shark_fin_3_animation.play("shark_fin3")

		# Restart the Shark Animation Timer after the animation plays
		shark_animation_timer.wait_time = rng.randf_range(10, 30)  # Reset to a new random time
		shark_animation_timer.start()
	)

func _on_game_over_timer_timeout() -> void:
	if game_over_shown:
		return

	print("Game Over Timer triggered")
	game_over_shown = true

	var game_over_menu_instance = GameOverMenuScene.instantiate()
	if game_over_menu_instance != null:
		print("GameOverMenu instance created, adding to scene.")
		add_child(game_over_menu_instance)
	else:
		print("Error: Failed to instantiate GameOverMenu.")
