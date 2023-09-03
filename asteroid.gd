class_name Asteroid
extends StaticBody2D

signal destroyed

@onready var hitbox = $Hitbox as CollisionShape2D
@onready var border = get_viewport_rect() as Rect2
@onready var sprite = $Sprite2D
@onready var particles = $Sprite2D/CPUParticles2D as CPUParticles2D

func _ready():
	randomize()
	rotation = 2 * PI * randf()

func _physics_process(delta):

	var collision: KinematicCollision2D
	collision = move_and_collide(constant_linear_velocity * delta)
	if not collision and not get_viewport_rect().has_point(global_position):
		loop_position()
		collision = move_and_collide(Vector2.ZERO, true)

	elif collision is KinematicCollision2D and collision.get_collider() is Asteroid:
		handle_collision(collision)

func loop_position():
	var margin = hitbox.shape.radius
	for ax in [Vector2.AXIS_X,Vector2.AXIS_Y]:
		if global_position[ax] < border.position[ax] - margin * .3:
			global_position[ax] = border.size[ax] + margin * .2
		if global_position[ax] > border.size[ax] + margin * .3:
			global_position[ax] = border.position[ax] - margin * .2

func handle_collision(collision: KinematicCollision2D):
	var asteroid: = collision.get_collider() as Asteroid
	$AudioLibrary.play("stone", .3)
	particles.emitting = true
	particles.scale_amount_max /= 2
	get_tree().create_timer(particles.lifetime).timeout.connect(
		func(): particles.scale_amount_max *= 2
	)
	var moment = constant_linear_velocity + asteroid.constant_linear_velocity
	if moment.is_zero_approx():
		moment = constant_linear_velocity

	moment *= 1.5

	constant_linear_velocity = - .5 * moment.reflect(
		collision.get_normal()
	)
	asteroid.constant_linear_velocity = + .5 * moment.reflect(
		collision.get_normal()
	)

func hit(force: Vector2):
	constant_linear_velocity = force

func destroy():
	$AudioLibrary.play("smash", .3)
	emit_signal("destroyed")
	sprite.self_modulate = Color.TRANSPARENT
	hitbox.set_deferred("disabled", true)
	particles.emitting = true
	emit_signal("destroyed")
	get_tree().create_timer(particles.lifetime).timeout.connect(queue_free)
