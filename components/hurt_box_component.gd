extends Area2D

signal get_damage(damage: float)

@export var armor := 0


func get_hurt(damage: float):
	var final_damage = max(damage - armor, 0)
	get_damage.emit(final_damage)
