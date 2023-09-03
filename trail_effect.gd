extends Line2D

const MAX_POINTS = 20
@onready var curve: = Curve2D.new()
@onready var butt_marker = $".."

func _ready():
	set_process(true)

func _process(_delta):
	curve.add_point(butt_marker.global_position)
	if curve.point_count > MAX_POINTS:
		curve.remove_point(0)

	clear_points()
	for p in curve.get_baked_points():
		add_point(to_local(p))

func start():
	set_process(true)

func clear():
	curve.clear_points()
	clear_points()
