extends State

@export var enemy: Node2D
@export var distance: float = 200
@export var search_component: Node2D
@export var nav_agent: NavigationAgent2D
@onready var timer: Timer = $Timer

var target_pos: Vector2
var noise: float = 50
var end_wander: bool


func _ready() -> void:
	set_nav_layer()
	end_wander = false


func set_nav_layer():
	nav_agent.set_navigation_layer_value(1, true)  # 草地
	nav_agent.set_navigation_layer_value(2, false)  # 路


func physics_update(_delta: float):
	if search_component.can_see_player():
		transitioned.emit(self, "EnemyNavAttack")
	else:
		if not end_wander:
			enemy.set_nav_to_target(target_pos)
			enemy.update_nav()
			if nav_agent.is_target_reached():
				find_next_point()
		else:
			# 上次巡逻时的位置
			target_pos = enemy.cur_pos
			enemy.set_nav_to_target(target_pos)
			enemy.update_nav()
			if nav_agent.is_target_reached():
				transitioned.emit(self, "EnemyNavPatrol")


func find_next_point():
	var rand_x = randf_range(-noise, noise)
	var rand_y = randf_range(-noise, noise)
	var rand_vec = Vector2(rand_x, rand_y)
	var pos = distance * enemy.transform.x + rand_vec
	target_pos = enemy.global_position + pos


func _on_timer_timeout() -> void:
	end_wander = true
