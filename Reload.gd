extends Label

func _ready():
	get_tree().create_timer(5).timeout.connect(
		fadeout
	)

func fadeout():
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.TRANSPARENT, 1)
