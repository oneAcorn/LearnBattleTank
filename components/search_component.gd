extends RayCast2D

var player_ref: Player


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_ref = get_tree().get_first_node_in_group("Player")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player_ref:
		look_at(player_ref.global_position)


func player_detect() -> bool:
	var obj = get_collider()
	if obj:
		return obj.is_in_group("Player")
	return false


#region detect_component公用接口


func can_see_player() -> bool:
	if get_player_angle() < PI / 2 and player_detect():
		return true
	return false


func get_player_pos():
	if player_ref:
		return player_ref.global_position


#endregion


func get_player_angle() -> float:
	var angle = transform.get_rotation()
	return abs(angle)
