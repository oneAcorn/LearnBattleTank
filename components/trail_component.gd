extends Node2D

@export var trail_scene: PackedScene
@export var trail_spacing: float = 22.0

@onready var target: Node2D = owner as Node2D
var _last_pos: Vector2


func _ready() -> void:
	_last_pos = target.global_position


func _process(_delta: float) -> void:
	var pos: Vector2 = target.global_position
	if pos.distance_to(_last_pos) < trail_spacing:
		return
	generate_trail(pos)
	_last_pos = pos


func generate_trail(pos: Vector2):
	var trail: Node2D = trail_scene.instantiate()
	trail.global_position = pos
	trail.rotation = target.rotation
	trail.top_level = true
	get_tree().current_scene.add_child(trail)
