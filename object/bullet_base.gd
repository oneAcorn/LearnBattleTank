extends Node2D

@export var speed: float = 400


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tw = create_tween()
	tw.set_loops()
	tw.tween_property(self, "modulate", Color("ff6e00"), 0.2)
	tw.tween_property(self, "modulate", Color("ffffff"), 0.2)


func _process(delta: float) -> void:
	position += transform.x * speed * delta


func _on_hit_box_component_hit() -> void:
	GameManager.bullet_hit.emit(global_position)
	queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
