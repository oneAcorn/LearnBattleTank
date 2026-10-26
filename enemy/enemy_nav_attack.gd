extends State

@export var enemy: Node2D
@export var search_component: Node2D
@export var weapon_component: Node2D
@export var nav_agent: NavigationAgent2D

var target_pos: Vector2
var min_dist := 150  # 地方单位与玩家的最小距离


func enter():
	set_nav_layer()


func physics_update(_delta: float):
	if search_component.can_see_player():
		target_pos = search_component.get_player_pos()
		if enemy.global_position.distance_to(target_pos) > min_dist:
			enemy.set_nav_to_target(target_pos)
			enemy.update_nav()
		else:
			enemy.stop()
		weapon_component.target(target_pos)
		weapon_component.shoot(target_pos)
	else:
		transitioned.emit(self, "EnemyNavWander")


func set_nav_layer():
	nav_agent.set_navigation_layer_value(1, true)
	nav_agent.set_navigation_layer_value(2, false)
