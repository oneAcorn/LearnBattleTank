extends Area2D


func get_player_pos():
	if has_overlapping_areas():
		var target = get_overlapping_areas()
		if not target.is_empty():
			return target[0].global_position
