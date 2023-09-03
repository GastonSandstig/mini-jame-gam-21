extends Node

@export var levels: Array[PackedScene]

var should_time = false

func _ready():
	$MarginContainer/VBoxContainer/Start.grab_focus()

func _on_music_toggled(button_pressed):
	Music.get_child(0).playing = button_pressed

func _on_start_pressed():
	if should_time:
		GlobalTimer.start()
	change_level(0)

func change_level(index: int):
	if index != 0:
		GlobalTimer.should_display(false)
	$AudioLibrary.play("jingle", 1.4)
	await $AudioLibrary/jingle.finished
	get_tree().change_scene_to_packed(levels[index])

func _on_timer_toggled(button_pressed):
	GlobalTimer.should_display(button_pressed)
	should_time = button_pressed
