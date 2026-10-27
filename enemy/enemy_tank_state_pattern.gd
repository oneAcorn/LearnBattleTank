extends CharacterBody2D

@export var points: Node2D
@export var speed: float = 100
@export var map_pcg: Node2D  # 程序化内容生成地图

@onready var weapon_component: Node2D = $WeaponComponent
@onready var detect_component: Node2D = $SearchComponent
@onready var hurt_box_component: Area2D = $HurtBoxComponent
@onready var health_component: Node = $HealthComponent
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D

var cur_pos: Vector2  # 上次巡逻位置


func _ready() -> void:
	set_cur_pos()


#region 公用接口


func set_cur_pos():
	cur_pos = global_position


func set_nav_to_target(target: Vector2):
	nav_agent.target_position = target


func update_nav():
	if not nav_agent.is_navigation_finished():
		var next_pos = nav_agent.get_next_path_position()
		update_direction(next_pos)
		var new_velocity = transform.x * speed
		if nav_agent.avoidance_enabled:
			# 交给agent计算安全速度(比如多个坦克走同一个路径,nav会计算每个坦克该以多少速度移动才能避免彼此相撞)
			nav_agent.velocity = new_velocity
		else:
			velocity = new_velocity
		move_and_slide()


func stop():
	if nav_agent.avoidance_enabled:
		nav_agent.velocity = Vector2.ZERO
	else:
		velocity = Vector2.ZERO


#endregion


func update_direction(target_pos: Vector2):
	var direction = global_position.direction_to(target_pos)
	var angle_rad = direction.angle()
	var delta = get_physics_process_delta_time()
	rotation = rotate_toward(rotation, angle_rad, 2 * PI * delta)


func move():
	velocity = speed * transform.x
	move_and_slide()


func _on_hurt_box_component_get_damage(damage: float) -> void:
	animation_player.play("flash")


func _on_health_component_died() -> void:
	GameManager.entity_died.emit(global_position, get_groups())
	queue_free()


func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity
