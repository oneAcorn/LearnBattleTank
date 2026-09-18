extends PathFollow2D

@export var speed: float = 100
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var trail_component = $TrailComponent
@onready var detect_component = $DetectComponent
@onready var weapon_component = $WeaponComponent


func _on_hurt_box_component_get_damage(damage: float) -> void:
	animation_player.play("flash")


func _on_health_component_died() -> void:
	GameManager.entity_died.emit(global_position, get_groups())
	queue_free()


func _process(delta: float) -> void:
	progress += speed * delta
	trail_component.start()
	find_player()


func find_player():
	var player_pos = detect_component.get_player_pos()
	if player_pos:
		weapon_component.target(player_pos)
