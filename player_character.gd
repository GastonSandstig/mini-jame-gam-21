class_name Player
extends CharacterBody2D

@export var health: = 3:
	set(value):
		health = value
		if health <= 0:
			dead.emit()
			ship_sprite.hide()

@export var pick_force: = 200

@export var ragdoll_duration: = .3
@export var invincibility_duration: = .8
var invincible = false

var exlusion_list: Array[Node2D] = []
const rot_offset = - PI / 2

signal hurt
signal dead

@onready var hitbox = $Hitbox as CollisionShape2D
@onready var player_controller = $PlayerController as PlayerController
@onready var ship_sprite = $ShipSprite as Sprite2D
@onready var border = get_viewport_rect()
@onready var audio_library = $AudioLibrary as AudioLibrary
@onready var animation_player = $AnimationPlayer
@onready var pick = $Pick

func _physics_process(delta):

	var collision: KinematicCollision2D
	collision = move_and_collide(velocity * delta)
	if not collision and not get_viewport_rect().has_point(global_position):
		loop_position()
		# Check for collisions at other side
		collision = move_and_collide(Vector2.ZERO, true)

	elif collision is KinematicCollision2D and collision.get_collider() is Asteroid:
		if not invincible:
			health -= 1
			audio_library.play("hurt")
			hurt.emit(health)
		handle_collision(collision)

	align_sprite()

func loop_position():
	var margin = hitbox.shape.radius
	for ax in [Vector2.AXIS_X,Vector2.AXIS_Y]:
		if global_position[ax] < border.position[ax] - margin * .5:
			global_position[ax] = border.size[ax] + margin * .4
			$ShipSprite/ButtMarker/Line2D.clear()
		if global_position[ax] > border.size[ax] + margin * .5:
			global_position[ax] = border.position[ax] - margin * .4
			$ShipSprite/ButtMarker/Line2D.clear()

func align_sprite():

	var traversal_direction = player_controller.get_traversal_direction()
	if traversal_direction.is_zero_approx(): return
	var current_direction = Vector2.RIGHT.rotated(ship_sprite.rotation)
	if PI/2 > traversal_direction.angle_to(current_direction):
		ship_sprite.rotation = lerp(
			ship_sprite.rotation,
			rot_offset + traversal_direction.angle(),
			get_physics_process_delta_time() * 20
		)
	else:
		ship_sprite.rotation = rot_offset + traversal_direction.angle()

func handle_collision(collision: KinematicCollision2D):
	var asteroid: = collision.get_collider() as Asteroid

	# Do a hit stop
	Engine.time_scale = .3
	get_tree().create_timer(.5 * Engine.time_scale).timeout.connect(
		func(): Engine.time_scale = 1.0
	)

	# Apply forces
	asteroid.constant_linear_velocity =  - 100 * collision.get_normal()
	velocity = 100 * collision.get_normal()

	if invincible: return
	# Momentarily take away control + invincibility
	player_controller.set_physics_process(false)
	get_tree().create_timer(ragdoll_duration).timeout.connect(
		player_controller.set_physics_process.bind(true)
	)
	invincible = true
	get_tree().create_timer(invincibility_duration).timeout.connect(
		func(): invincible = false
	)

func swing_pick():
	if animation_player.is_playing(): return
	exlusion_list.clear()
	pick.rotation = ship_sprite.rotation
	animation_player.play("swing_pick")
	audio_library.play("woosh")

func _on_hitbox_body_entered(body):

	if body is Asteroid and not exlusion_list.has(body):

		exlusion_list.append(body)

		# Do a hit stop
		Engine.time_scale = .3
		get_tree().create_timer(.5 * Engine.time_scale).timeout.connect(
			func(): Engine.time_scale = 1.0
		)

		body.hit(pick_force * Vector2.RIGHT.rotated(pick.rotation - rot_offset))
		if body is SmallAsteroid: return
		velocity = - .2 * pick_force * Vector2.RIGHT.rotated(pick.rotation - rot_offset)

		# Momentarily take away control
		player_controller.set_physics_process(false)
		get_tree().create_timer(ragdoll_duration).timeout.connect(
			player_controller.set_physics_process.bind(true)
		)
