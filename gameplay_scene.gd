extends Node

@export var next_level: PackedScene

@onready var health_bar = %HealthBar
@onready var player = $PlayerCharacter as Player
@onready var remaing_asteroids = %RemaingAsteroids

var _is_changing_levels = false

func _ready():
	player.dead.connect(
		change_level.bind(true)
	)
	health_bar.max_value = player.health
	health_bar.value = player.health
	remaing_asteroids.text = "Remaining asteroids: %d" % get_tree().get_nodes_in_group("asteroids").size()

func _on_player_character_hurt(health):
	health_bar.value = health

func spawn_asteroid(size = "small", amount = 1, position = Vector2.ZERO):
	const small = preload("res://SmallAsteroid.tscn")
	var new_children: Array[Asteroid] = []
	for i in amount:
		match size:
			"small":
				new_children.append(small.instantiate())

		call_deferred("add_child", new_children[i])
	await get_tree().process_frame
	for i in amount:
		new_children[i].add_to_group("asteroids")
		new_children[i].hitbox.disabled = true
		get_tree().create_timer(.6).timeout.connect(
			func(): new_children[i].hitbox.disabled = false
		)
		new_children[i].position = position
		new_children[i].constant_linear_velocity = - 200 * new_children[i].global_position.direction_to(
			player.global_position
		).rotated(i * PI/2/amount - PI/4)

func _on_child_order_changed():
	if _is_changing_levels: return
	remaing_asteroids.text = "Remaining asteroids: %d" % get_tree().get_nodes_in_group(
		"asteroids"
	).size()
	if get_tree().get_nodes_in_group("asteroids").is_empty():
		change_level()

func change_level(respawn = false):
	_is_changing_levels = true
	$CanvasModulate.show()

	# Do a hit stop
	Engine.time_scale = .3
	var timer = get_tree().create_timer(3 * Engine.time_scale)
	timer.timeout.connect(
		func(): Engine.time_scale = 1.0
	)
	if not respawn:
		$CanvasLayer/RichTextLabel2.show()
		$AudioLibrary.play("jingle")
		await timer.timeout
		get_tree().change_scene_to_packed(next_level)
	else:
		await timer.timeout
		get_tree().reload_current_scene()

func _input(event):
	if event.is_action("reload"):
		change_level(true)
