class_name ScreenShakeEffect
extends Node

var camera: Camera2D
var tween: Tween

func trigger():
	camera = get_viewport().get_camera_2d()

	if tween:
		tween.kill()
	tween = create_tween()
	tween.set_loops(3)
	camera.offset = Vector2.RIGHT * 5
	tween.tween_callback(random_offset)
	tween.tween_interval(.1)
	tween.finished.connect(func(): camera.offset = Vector2.ZERO)

func random_offset():
	camera.offset = -camera.offset.rotated((PI / 4) * randf_range(-1,1))
