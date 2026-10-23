extends Node2D

@export var speed: float = 300
@onready var detect_component: Area2D = $DetectComponent


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if detect_component.can_see_player():
		update_direction(detect_component.get_player_pos(), delta)
	move_forward(delta)


func update_direction(target_pos: Vector2, delta: float):
	var direction = global_position.direction_to(target_pos)
	var angle_rad = direction.angle()
	rotation = rotate_toward(rotation, angle_rad, 2 * PI * delta)


func move_forward(delta):
	position += transform.x * speed * delta


func _on_hit_box_component_hit() -> void:
	GameManager.bullet_hit.emit(global_position)
	queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_health_component_died() -> void:
	GameManager.entity_died.emit(global_position, get_groups())
	queue_free()
