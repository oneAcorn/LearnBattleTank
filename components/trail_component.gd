extends Node2D

@export var trail_scene: PackedScene
@onready var timer: Timer = $Timer


func _on_timer_timeout() -> void:
	pass  # Replace with function body.


func start():
	if timer.is_stopped():
		timer.start()


func stop():
	if not timer.is_stopped():
		timer.stop()


func generate_trail():
	var trail: Node2D = trail_scene.instantiate()
	trail.global_position = owner.global_position
	trail.rotation = owner.rotation
	trail.top_level = true
	add_child(trail)
