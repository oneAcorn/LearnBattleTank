extends Area2D

signal hit

@export var damage := 1  # 基础伤害
@export var hit_multiple := false  # 是否群伤


func _on_area_entered(area: Area2D) -> void:
	hit.emit()
	apply_hit(area)


func _on_body_entered(body: Node2D) -> void:
	hit.emit()


func apply_hit(hurt_box: Area2D):
	if hurt_box.has_method("get_hurt"):
		hurt_box.get_hurt(damage)
	set_deferred("monitoring", hit_multiple)
