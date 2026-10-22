extends CharacterBody2D

## sample FSM(Finite State Machine) 状态变量有限状态机

enum FSMState { Patrol, Chase }
var direction := Vector2.RIGHT
var points_arr: Array  # 坦克移动时需要经过的巡逻点
var target_pos: Vector2
var target_index: int = 0
var player_pos = null
var cur_state = FSMState.Patrol
@export var points: Node2D  # 用来收纳巡逻路径点

@export var speed: float = 100
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var detect_component = $DetectComponent
@onready var weapon_component = $WeaponComponent


func _ready() -> void:
	material.set_shader_parameter("active", false)
	weapon_component.material.set_shader_parameter("active", false)
	get_points()
	find_next_point()


func _on_hurt_box_component_get_damage(damage: float) -> void:
	animation_player.play("flash")


func _on_health_component_died() -> void:
	GameManager.entity_died.emit(global_position, get_groups())
	queue_free()


func _physics_process(delta: float) -> void:
	FSM_update()


func get_points():
	if points is Path2D:
		for p in points.curve.get_baked_points():
			points_arr.append(points.to_global(p))
	else:
		for point in points.get_children():
			points_arr.append(point.global_position)


func find_next_point():
	if target_index >= points_arr.size():
		target_index = 0
	target_pos = points_arr[target_index]
	target_index += 1


func update_direction():
	direction = global_position.direction_to(target_pos)
	var angle_rad = direction.angle()
	rotation = angle_rad


func move_to_target():
	velocity = transform.x * speed
	move_and_slide()


func near_point():
	if global_position.distance_to(target_pos) < 5:
		return true
	else:
		return false


func FSM_update():
	match cur_state:
		FSMState.Patrol:
			update_patrol()
		FSMState.Chase:
			update_chase()


func update_patrol():
	update_direction()
	move_to_target()
	if near_point():
		find_next_point()
	if find_player():
		cur_state = FSMState.Chase


func update_chase():
	if find_player():
		target_pos = player_pos
		update_direction()
		move_to_target()
		attack_player()
	else:
		cur_state = FSMState.Patrol


func attack_player():
	weapon_component.target(player_pos)
	weapon_component.shoot(player_pos)


func find_player():
	player_pos = detect_component.get_player_pos()
	if player_pos:
		return true
	else:
		return false
