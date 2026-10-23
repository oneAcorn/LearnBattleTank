extends Area2D

var player_pos = null

var player_ref: Player


func can_see_player():
	if has_overlapping_bodies():
		var targets = get_overlapping_bodies()
		if not targets.is_empty():
			player_ref = targets[0]
			return true
	return false


func get_player_pos():
	if player_ref:
		return player_ref.global_position
