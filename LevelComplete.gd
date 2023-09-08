extends Node

func _ready():
	GlobalTimer.stop()

func _on_button_pressed():
	get_tree().change_scene_to_packed(load("res://LevelSelect.tscn"))
	GlobalTimer.reset()
