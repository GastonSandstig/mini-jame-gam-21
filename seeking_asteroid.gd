class_name SeekingAsteroid
extends Asteroid

@export var player: Player
@export var durability: = 3

func _process(delta):
	var seek_dir: = global_position.direction_to(player.global_position)
	rotation = lerp(
		rotation,
		seek_dir.angle(),
		.5
	)
	constant_linear_velocity = constant_linear_velocity.lerp(
		200 * seek_dir,
		.01
	)

func hit(force: Vector2):
	constant_linear_velocity = force
	rotation = force.angle() + randf_range(-.5, .5)
	durability -= 1
	$AudioLibrary.play("stone")
	set_process(false)
	get_tree().create_timer(.3).timeout.connect(
		set_process.bind(true)
	)
	if durability <= 0:
		destroy()
