extends RefCounted
class_name PathGenerator

var _map_top_left: Vector2i
var _map_bottom_right: Vector2i
var _start_pos: Vector2i
var _stop_pos: Vector2i
var _points_num: int
var _path_points: Array[Vector2i]
var _random_points: Array[Vector2i]


func setup(map_top_left, map_bottom_right, start_pos, stop_pos, points_num):
	_map_top_left = map_top_left
	_map_bottom_right = map_bottom_right
	_start_pos = start_pos
	_stop_pos = stop_pos
	_points_num = points_num


func find_nearest_point(start: Vector2i, points: Array[Vector2i]):
	var dist_array: Array
	for point in points:
		dist_array.append([point, start.distance_squared_to(point)])
	dist_array.sort_custom(sort_ascending)
	return dist_array[0][0]


func generate_random_points() -> Array[Vector2i]:
	for i in range(_points_num):
		var rand_x = randi_range(_map_top_left.x, _map_bottom_right.x)
		var rand_y = randi_range(_map_top_left.y, _map_bottom_right.y)
		_random_points.append(Vector2i(rand_x, rand_y))
	var nearest_start = _start_pos

	for i in range(_points_num):
		var nearest_point = find_nearest_point(nearest_start, _random_points)
		var mid_points = [Vector2i(nearest_start.x, nearest_point.y), Vector2i(nearest_point.x, nearest_start.y)]
		var mid_point = mid_points.pick_random()
		_path_points.append(mid_point)
		_path_points.append(nearest_point)
		nearest_start = nearest_point
		_random_points.erase(nearest_point)
	return _path_points


func sort_ascending(a, b):
	if a[1] < b[1]:
		return true
	return false
