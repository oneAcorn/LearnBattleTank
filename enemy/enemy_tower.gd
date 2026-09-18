extends StaticBody2D

@onready var detect_component: Area2D = $DetectComponent
@onready var weapon_component: Node2D = $WeaponComponent
@onready var hurt_box_component: Area2D = $HurtBoxComponent
@onready var health_component: Node = $HealthComponent
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _on_hurt_box_component_get_damage(damage: float) -> void:
	animation_player.play("flash")


func _on_health_component_died() -> void:
	GameManager.entity_died.emit(global_position, get_groups())
	queue_free()


func find_player():
	var player_pos: Node2D = detect_component.get_player_pos()
	if player_pos:
		weapon_component.target(player_pos)
		weapon_component.shoot(player_pos)
