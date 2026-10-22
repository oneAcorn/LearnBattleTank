extends Area2D

var player_pos = null


func get_player_pos():
	if has_overlapping_areas():
		var target = get_overlapping_areas()
		if not target.is_empty():
			return target[0].global_position


func find_player():
	player_pos = get_player_pos()
	if player_pos:
		return true
	else:
		return false
