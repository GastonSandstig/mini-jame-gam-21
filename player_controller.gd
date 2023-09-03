class_name PlayerController
extends Node

@export var MAX_SPEED: = 400.0
@export var ACCCELERATION: = 400.0

@onready var player: = get_parent() as Player


func _physics_process(delta):

	# Accelerate
	player.velocity += ACCCELERATION * get_traversal_direction() * delta * .5
	player.velocity = player.velocity.limit_length(MAX_SPEED)
	player.velocity += ACCCELERATION * get_traversal_direction() * delta * .5

func get_traversal_direction() -> Vector2:
	return Vector2(
		Input.get_axis("travel_left", "travel_right"),
		Input.get_axis("travel_up", "travel_down")
	).normalized()

func _input(event):

	if event.is_action("swing_pick") and Input.is_action_just_pressed("swing_pick"):
		player.swing_pick()
