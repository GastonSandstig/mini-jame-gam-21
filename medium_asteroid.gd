class_name MediumAsteroid
extends Asteroid

@export var durability: = 2

func hit(force: Vector2):
	constant_linear_velocity = force
	rotation = force.angle() + randf_range(-.5, .5)
	durability -= 1
	$AudioLibrary.play("stone")
	if durability <= 0:
		get_tree().root.get_node("GameplayScene").spawn_asteroid("small", 3, global_position)
		destroy()
