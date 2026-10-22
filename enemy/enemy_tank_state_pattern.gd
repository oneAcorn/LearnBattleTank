extends CharacterBody2D

@export var points: Node2D
@export var speed: float = 100
@onready var weapon_component: Node2D = $WeaponComponent
@onready var detect_component: Area2D = $DetectComponent
@onready var hurt_box_component: Area2D = $HurtBoxComponent
@onready var health_component: Node = $HealthComponent
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func update_direction(target_pos: Vector2):
	var direction = global_position.direction_to(target_pos)
	var angle_rad = direction.angle()
	rotation = angle_rad


func move():
	velocity = speed * transform.x
	move_and_slide()


func _on_hurt_box_component_get_damage(damage: float) -> void:
	animation_player.play("flash")


func _on_health_component_died() -> void:
	GameManager.entity_died.emit(global_position, get_groups())
	queue_free()
