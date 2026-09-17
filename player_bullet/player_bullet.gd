extends Area2D

@export var speed: float = 100


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# 沿自身前方(受rotation影响)运动
	position += transform.x * speed * delta


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Enemy"):
		area.reduce_health()
		queue_free()
