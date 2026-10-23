extends State

@export var enemy: Node2D
@export var detect_component: Node2D
@export var weapon_component: Node2D

var target_pos: Vector2


func physics_update(_delta: float):
	if detect_component.can_see_player():
		target_pos = detect_component.get_player_pos()
		enemy.update_direction(target_pos)
		enemy.move()
		weapon_component.target(target_pos)
		weapon_component.shoot(target_pos)
	else:
		transitioned.emit(self, "EnemyWander")
