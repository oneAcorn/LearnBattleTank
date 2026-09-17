extends Node

signal died
signal health_changed(health_percent: float)

@export var max_health: float = 5
@onready var current_health: float = max_health


func get_health_percent():
	if current_health <= 0:
		return 0
	return min(current_health / max_health, 1)


func get_damage(damage_value: float):
	current_health = max(current_health - damage_value, 0)
	health_changed.emit(get_health_percent())
	check_death()


func check_death():
	if current_health <= 0:
		died.emit()


# 血量升级
func upgrade(value):
	current_health = min(max_health, current_health + value)
	health_changed.emit(get_health_percent())
