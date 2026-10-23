extends State

@export var enemy: Node2D
@export var distance: float = 200
@export var search_component: Node2D
@onready var timer: Timer = $Timer

var target_pos: Vector2
var noise: float = 50
var end_wander: bool


func physics_update(_delta: float):
	if search_component.can_see_player():
		transitioned.emit(self, "EnemyAttack")
	else:
		if not end_wander:
			enemy.update_direction(target_pos)
			enemy.move()
			if near_point():
				find_next_point()
		else:
			transitioned.emit(self, "EnemyPatrol")


func find_next_point():
	var random_x = randf_range(-noise, noise)
	var random_y = randf_range(-noise, noise)
	var random_vec = Vector2(random_x, random_y)
	var pos = distance * enemy.transform.x + random_vec
	target_pos = enemy.global_position + pos


func near_point():
	if enemy.global_position.distance_to(target_pos) < 5:
		return true
	else:
		return false


func enter():
	end_wander = false
	find_next_point()
	timer.start(10)


func _on_timer_timeout() -> void:
	end_wander = true
