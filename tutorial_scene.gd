extends Node

@export var next_level: PackedScene

@onready var health_bar = %HealthBar
@onready var player = $PlayerCharacter as Player

func _ready():
	health_bar.max_value = player.health
	health_bar.value = player.health

func change_level():
	$CanvasModulate.show()
	$CanvasLayer/RichTextLabel2.show()
	$AudioLibrary.play("jingle")
	# Do a hit stop
	Engine.time_scale = .3
	var timer = get_tree().create_timer(3 * Engine.time_scale)
	timer.timeout.connect(
		func(): Engine.time_scale = 1.0
	)
	await timer.timeout
	get_tree().change_scene_to_packed(next_level)


func _on_area_2d_body_entered(body):
	change_level()
