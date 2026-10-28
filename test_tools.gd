@tool
extends Sprite2D


func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		rotation_degrees += 1
	else:
		rotation_degrees -= 1
