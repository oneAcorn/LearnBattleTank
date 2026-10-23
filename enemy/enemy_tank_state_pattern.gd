extends CharacterBody2D

@export var points: Node2D
@export var speed: float = 100
@onready var weapon_component: Node2D = $WeaponComponent
@onready var detect_component: Node2D = $SearchComponent
@onready var hurt_box_component: Area2D = $HurtBoxComponent
@onready var health_component: Node = $HealthComponent
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var avoid_component: Node2D = $AvoidComponent


func update_direction(target_pos: Vector2):
	var direction = global_position.direction_to(target_pos)
	if avoid_component.obstackes_detected():
		direction = avoid_component.get_new_direction()
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
