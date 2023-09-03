extends MenuButton

func _ready():
	var level_select = $"../../.."
	get_popup().id_pressed.connect(
		level_select.change_level
	)
	for lvl in level_select.levels.size():
		get_popup().add_item(
			"Level %d" % lvl
		)
