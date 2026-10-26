@tool
extends EditorScript

const GRASS_LAYER := "Grass"
const OBSTACLE_LAYERS := ["Border", "Items", "Tree"]
const PHYSICS_LAYERS := [0]  # TileSet 物理层索引；要连 PlayerOnlyBarrier 一起处理就加 1
const WALK_TILE := Vector2i(0, 0)  # 带导航的草地
const GROUND_TILE := Vector2i(0, 1)  # 去掉导航的草地


func _run() -> void:
	var root := EditorInterface.get_edited_scene_root()
	if root == null or root.name != "Map":
		push_error("请先打开 map/map.tscn 再运行")
		return
	var grass := root.get_node_or_null(GRASS_LAYER) as TileMapLayer
	if grass == null:
		push_error("找不到 Grass 图层")
		return

	# 先把上次铺的障碍物背景恢复成普通草地，保证脚本可以重复运行
	for cell in grass.get_used_cells():
		if grass.get_cell_source_id(cell) == 0 and grass.get_cell_atlas_coords(cell) == GROUND_TILE:
			grass.set_cell(cell, 0, WALK_TILE)

	var changed := 0
	for layer_name in OBSTACLE_LAYERS:
		var layer := root.get_node_or_null(layer_name) as TileMapLayer
		if layer == null:
			continue
		for cell in layer.get_used_cells():
			var source := layer.tile_set.get_source(layer.get_cell_source_id(cell)) as TileSetAtlasSource
			if source == null:
				continue
			var data := source.get_tile_data(layer.get_cell_atlas_coords(cell), layer.get_cell_alternative_tile(cell))
			for physics_layer in PHYSICS_LAYERS:
				if data.get_collision_polygons_count(physics_layer) > 0:
					grass.set_cell(cell, 0, GROUND_TILE)
					changed += 1
					break

	print("完成：%d 个障碍物格已替换为无导航草地。" % changed)
	EditorInterface.mark_scene_as_unsaved()
