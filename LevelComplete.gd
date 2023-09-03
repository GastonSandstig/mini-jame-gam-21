extends Node


@export var startmenu: PackedScene

func _ready():
	GlobalTimer.stop()

func _on_button_pressed():
	get_tree().change_scene_to_packed(startmenu)
	GlobalTimer.reset()
