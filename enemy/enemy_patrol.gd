extends State

@export var enemy: Node2D
@export var detect_component: Node2D

var points_arr: Array
var target_pos: Vector2
var target_index: int = 0


func _ready() -> void:
	get_points()
	find_next_point()


func physics_update(_delta: float):
	enemy.update_direction(target_pos)
	enemy.move()
	if near_point():
		find_next_point()
	if detect_component.can_see_player():
		transitioned.emit(self, "EnemyAttack")


func get_points():
	var points = enemy.points
	if points is Path2D:
		for p in points.curve.get_baked_points():
			points_arr.append(points.to_global(p))
	else:
		for point in points.get_children():
			points_arr.append(point.global_position)
	#print("enemy patrol points arr:%s" % points)


func find_next_point():
	if target_index >= points_arr.size():
		target_index = 0
	target_pos = points_arr[target_index]
	target_index += 1


func near_point():
	if enemy.global_position.distance_to(target_pos) < 5:
		return true
	else:
		return false
