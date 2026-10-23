extends CharacterBody2D

@export var points: Node2D

@export var speed: float = 100
@onready var weapon_component: Node2D = $MissileLaunchComponent
@onready var detect_component: Area2D = $DetectComponent
@onready var avoid_component: Node2D = $AvoidComponent
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	material.set_shader_parameter("active", false)
	weapon_component.material.set_shader_parameter("active", false)


func update_direction(target_pos: Vector2):
	var direction = global_position.direction_to(target_pos)
	if avoid_component.obstackes_detected():
		direction = avoid_component.get_new_direction()
	var angle_rad = direction.angle()
	var delta = get_physics_process_delta_time()
	rotation = rotate_toward(rotation, angle_rad, 2 * PI * delta)


func move():
	velocity = transform.x * speed
	move_and_slide()


func _on_health_component_died() -> void:
	GameManager.entity_died.emit(global_position, get_groups())
	queue_free()


func _on_hurt_box_component_get_damage(damage: float) -> void:
	animation_player.play("flash")
