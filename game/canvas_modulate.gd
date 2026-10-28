extends CanvasModulate

@export var map_colors: Array[Color]


func _ready() -> void:
	if map_colors.is_empty():
		return
	var index := (GameManager.current_level - 1) % map_colors.size()
	color = map_colors[index]
