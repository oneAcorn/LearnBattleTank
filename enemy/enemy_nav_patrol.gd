extends State

@export var enemy: Node2D
@export var nav_agent: NavigationAgent2D
@export var search_component: Node2D
var patrol_points: Array
var patrol_target: Vector2


func _ready() -> void:
	get_patrol_point()


func enter():
	get_next_patrol_point()
	set_nav_layer()


func physics_update(_delta: float):
	enemy.set_nav_to_target(patrol_target)
	enemy.update_nav()
	if enemy.nav_agent.is_target_reached():
		enemy.set_cur_pos()
		get_next_patrol_point()
	if search_component.can_see_player():
		transitioned.emit(self, "EnemyNavAttack")


func get_patrol_point():
	var points = enemy.points
	if points is Path2D:
		for p in points.curve.get_baked_points():
			patrol_points.append(points.to_global(p))
	else:
		for point in points.get_children():
			patrol_points.append(point.global_position)


func set_nav_layer():
	nav_agent.set_navigation_layer_value(2, true)  # 沿road巡逻
	nav_agent.set_navigation_layer_value(1, false)  # 1:草地


func get_next_patrol_point():
	patrol_target = patrol_points.pick_random()
