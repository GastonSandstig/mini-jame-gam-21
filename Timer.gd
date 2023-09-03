extends Control

var start_msec: = 0.0
var sec: = 0.0

var is_timing: = false

@onready var label = $CenterContainer/Label

func _process(delta):
	if is_timing:
		sec = 1.0 / 1000.0 * (Time.get_ticks_msec() - start_msec)
		label.text = "%07.3f" % sec

func should_display(val: bool):
	label.visible = val

func start():
	is_timing = true
	label.show()
	start_msec = Time.get_ticks_msec()

func stop():
	is_timing = false

func reset():
	is_timing = false
	label.hide()
	sec = 0.0
