extends Line2D

@export var length = 3
@onready var parent: Node2D = get_parent()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	clear_points()
	top_level = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	add_point(parent.global_position)
	if points.size() > length:
		remove_point(0)
