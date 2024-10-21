extends RigidBody2D  # Ensure your script extends RigidBody2D

#@onready var player: CharacterBody2D = get_parent().get_node("player")  # Adjust the path accordingly
#@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
#
#func _ready():
	#collision_shape_2d.connect("body_entered", self, "_on_body_entered")
#
#func _on_body_entered(body):
	#if body == player:
		#queue_free()
