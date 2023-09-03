class_name SmallAsteroid
extends Asteroid

@export var durability: = 1

func hit(force: Vector2):
	constant_linear_velocity = force
	rotation = force.angle() + randf_range(-.5, .5)
	destroy()
