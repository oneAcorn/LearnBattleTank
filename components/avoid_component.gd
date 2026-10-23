extends ShapeCast2D

@export var force: float = 2


func obstackes_detected() -> bool:
	return is_colliding()


func get_new_direction():
	if obstackes_detected():
		var normal_vec = get_collision_normal(0)
		var direction = owner.transform.x + normal_vec * force
		return direction
