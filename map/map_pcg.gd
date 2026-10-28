extends Node2D

## 程序化内容生成（Procedural Content Generation，简称 PCG）地图

@onready var grass: TileMapLayer = $Grass
@onready var border: TileMapLayer = $Border
@onready var road: TileMapLayer = $Road
@onready var items: TileMapLayer = $Items
@onready var tree: TileMapLayer = $Tree

@export var map_size = Vector2i(45, 22)  # 地图尺寸
@export var points: Node2D  # 用于储存玩家和敌人的出生点
@export var path_point_count = 5

const grass_id: int = 0  # 草地的图集ID
const nav_grass_atlas = Vector2i(0, 0)  # 导航草地的图集编号
const border_tree_id: int = 1
const border_tree_atlas = Vector2i(0, 0)
const no_nav_grass_atlas = Vector2i(0, 1)
const stone_id: int = 3
const stone_atlas := [Vector2i(0, 0), Vector2i(1, 0), Vector2i(2, 0)]
const brown_tree_id: int = 2
const brown_tree_atlas := Vector2i(0, 0)

var enemy_start_pos: Vector2
var enemy_start: Vector2i
var player_start_pos: Vector2
var player_start: Vector2i
var path_top_left: Vector2i
var path_bottom_right: Vector2i

var enemy_safe_area: Array
var player_safe_area: Array

var path_cell: Array[Vector2i]
var astargrid := AStarGrid2D.new()
var path_generator := PathGenerator.new()
var free_cell: Array  # 存储除安全区域,道路外的可导航草地区域. 用于放置装饰物或障碍物.


func _ready() -> void:
	set_map_parameter()
	setup_grass()
	setup_safe_area()
	setup_border()
	setup_astargrid()
	setup_pathgenerator()
	get_random_path()
	get_random_path()
	setup_free_cell()
	setup_stones()
	setup_deco_trees()


func is_on_road(pos: Vector2):
	var cell = road.local_to_map(pos)
	var road_cells = road.get_used_cells()
	if cell in road_cells:
		return true
	return false


func setup_grass():
	grass.clear()
	for cell_x in range(map_size.x):
		for cell_y in range(map_size.y):
			grass.set_cell(Vector2i(cell_x, cell_y), grass_id, nav_grass_atlas)


func setup_astargrid():
	astargrid.region = grass.get_used_rect()
	var cell_size = grass.tile_set.tile_size
	astargrid.cell_size = cell_size
	astargrid.offset = cell_size / 2
	# 寻路算法是否允许对角线移动
	astargrid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astargrid.update()


func setup_pathgenerator():
	path_generator.setup(path_top_left, path_bottom_right, enemy_start, player_start, path_point_count)


func get_random_path():
	var path_points := path_generator.generate_random_points()
	var path_start = enemy_start
	for point in path_points:
		path_cell.append_array(astargrid.get_id_path(path_start, point))
		path_start = point
	var path_end = player_start
	path_cell.append_array(astargrid.get_id_path(path_start, path_end))
	road.set_cells_terrain_connect(path_cell, 0, 0)


## 收集start_cell两层范围内所有区域,并且使用dictionary去重
func _collect_safe_area(start_cell: Vector2i) -> Array:
	var result: Dictionary = {}

	var first_ring = grass.get_surrounding_cells(start_cell)
	result[start_cell] = true
	for cell in first_ring:
		result[cell] = true

	for cell in first_ring:
		for neighbor in grass.get_surrounding_cells(cell):
			result[neighbor] = true
	return result.keys()


func setup_safe_area():
	enemy_safe_area = _collect_safe_area(enemy_start)
	player_safe_area = _collect_safe_area(player_start)


func setup_border():
	var border_top_left = Vector2i.ZERO - Vector2i.ONE
	var border_bottom_right = map_size
	for c_x in range(border_top_left.x, border_bottom_right.x + 1):
		grass.set_cell(Vector2i(c_x, border_top_left.y), grass_id, no_nav_grass_atlas)
		grass.set_cell(Vector2i(c_x, border_bottom_right.y), grass_id, no_nav_grass_atlas)
		border.set_cell(Vector2i(c_x, border_top_left.y), border_tree_id, border_tree_atlas)
		border.set_cell(Vector2i(c_x, border_bottom_right.y), border_tree_id, border_tree_atlas)
	for c_y in range(border_top_left.y, border_bottom_right.y + 1):
		grass.set_cell(Vector2i(border_top_left.x, c_y), grass_id, no_nav_grass_atlas)
		grass.set_cell(Vector2i(border_bottom_right.x, c_y), grass_id, no_nav_grass_atlas)
		border.set_cell(Vector2i(border_top_left.x, c_y), border_tree_id, border_tree_atlas)
		border.set_cell(Vector2i(border_bottom_right.x, c_y), border_tree_id, border_tree_atlas)


func setup_free_cell():
	var grass_cell = grass.get_used_cells_by_id(grass_id, nav_grass_atlas)
	var road_cell = road.get_used_cells()
	for cell in grass_cell:
		if cell not in road_cell and cell not in enemy_safe_area and cell not in player_safe_area:
			free_cell.append(cell)


func setup_stones(item_num: int = 8):
	for i in range(item_num):
		_set_items(items, 0.6, stone_id, stone_atlas, true)


func setup_deco_trees(item_num: int = 12):
	for i in range(item_num):
		_set_items(items, 0.66, brown_tree_id, [brown_tree_atlas], false)


func get_patrol_points(patrol_num: int = 5):
	var patrol_points: Array
	var road_cells = road.get_used_cells()
	for i in range(patrol_num):
		var pick_point = road_cells.pick_random()
		road_cells.erase(pick_point)
		patrol_points.append(road.map_to_local(pick_point))
	return patrol_points


func get_tower_points(tower_num: int = 5, max_try: int = 100):
	var road_cells = road.get_used_cells()
	var tower_points: Array
	var try_count: int = 0
	for i in range(tower_num):
		while try_count < max_try:
			var rand_point = road_cells.pick_random()
			var surround_cell = grass.get_surrounding_cells(rand_point)
			var available_cell = get_surround_free_cell(surround_cell)
			if available_cell:
				grass.set_cell(available_cell, grass_id, no_nav_grass_atlas)
				tower_points.append(grass.map_to_local(available_cell))
				break
			else:
				try_count += 1
	return tower_points


func get_surround_free_cell(surround_cell: Array[Vector2i]):
	for cell in surround_cell:
		if cell in free_cell:
			var point = grass.map_to_local(cell)
			if point.distance_to(player_start_pos) > 400:
				return cell
	return null


## 设置装饰物或障碍物
## [param prob] 邻近区域是否也填充的概率
## [param cannot_nav] 是否影响导航; 此方法中石头为true,树为false;
func _set_items(tile: TileMapLayer, prob: float, item_id: int, item_atlas: Array, cannot_nav: bool):
	var cell = free_cell.pick_random()
	_place_item_at(cell, tile, item_id, item_atlas, cannot_nav)
	var near_cells = tile.get_surrounding_cells(cell)
	for c in near_cells:
		if randf_range(0, 1) < prob and c in free_cell:
			_place_item_at(c, tile, item_id, item_atlas, cannot_nav)


func _place_item_at(cell: Vector2i, tile: TileMapLayer, item_id: int, item_atlases: Array, cannot_nav: bool) -> void:
	if cannot_nav:
		grass.set_cell(cell, grass_id, no_nav_grass_atlas)
	tile.set_cell(cell, item_id, item_atlases.pick_random())
	free_cell.erase(cell)


func set_map_parameter():
	enemy_start_pos = points.get_node("EnemyStart").global_position
	enemy_start = grass.local_to_map(enemy_start_pos)
	player_start_pos = points.get_node("PlayerStart").global_position
	player_start = grass.local_to_map(player_start_pos)
	path_top_left = grass.local_to_map(points.get_node("TopLeft").global_position)
	path_bottom_right = grass.local_to_map(points.get_node("BottomRight").global_position)
