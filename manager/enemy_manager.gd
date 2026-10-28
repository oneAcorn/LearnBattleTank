extends Node

signal wave_died

@export var map_pcg: Node2D
@export var enemy_tank_scene: Array[PackedScene] = []
@export var enemy_tower_scene: PackedScene
@export var enemy_spawn_time: int = 2  # 敌人出生时间间隔
@export var enemies_holder: Node2D  # 敌人节点容器
@export var enemy_tower_number: int = 5

var died_tank: int
var died_enemy: int
var total_enemy_size: int
var tower_points: Array

var wave_number: int = GameManager.current_level + 1  # 敌方攻击波次数量
var enemy_in_wave: int = GameManager.current_level + 3  # 每个波次的坦克数量


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tower_points = map_pcg.get_tower_points(enemy_tower_number)
	GameManager.entity_died.connect(on_entity_died)
	GameManager.level_start.connect(on_level_start)
	spawn_tower()
	check_enemy_size()


func on_level_start():
	wave_number = GameManager.current_level + 1
	enemy_in_wave = GameManager.current_level + 3
	spawn_waves()


func get_enemy_data():
	var data: Dictionary
	data["wave"] = wave_number
	data["enemy"] = total_enemy_size
	return data


func spawn_tower():
	for point in tower_points:
		var enemy_tower = enemy_tower_scene.instantiate()
		enemies_holder.add_child(enemy_tower)
		enemy_tower.global_position = point


func on_entity_died(_pos: Vector2, groups: Array):
	check_wave_end(groups)
	check_killed_enemy(groups)


func spawn_waves():
	for i in wave_number:
		await spawn_wave()
		await wave_died


func spawn_wave():
	died_tank = 0
	for i in enemy_in_wave:
		call_deferred("spawn_enemy")
		await get_tree().create_timer(enemy_spawn_time).timeout


func spawn_enemy():
	var enemy_tank = enemy_tank_scene.pick_random().instantiate()
	enemy_tank.speed = randi_range(100, 150)
	if enemy_tank is CharacterBody2D:
		#enemy_tank.points = path
		#enemy_tank.global_position = path.to_global(path.curve.get_point_position(0))
		enemy_tank.map_pcg = map_pcg
		enemy_tank.global_position = map_pcg.enemy_start_pos
		enemies_holder.add_child(enemy_tank)


func check_wave_end(groups):
	if "EnemyTank" in groups:
		died_tank += 1
		if died_tank == enemy_in_wave:
			wave_died.emit()


func check_killed_enemy(groups):
	if "Enemy" in groups:
		died_enemy += 1
		GameManager.score_update.emit()
		if died_enemy == total_enemy_size:
			GameManager.player_win.emit()


func check_enemy_size():
	for enemy in enemies_holder.get_children():
		if "EnemyTower" in enemy.get_groups():
			total_enemy_size += 1
	total_enemy_size += wave_number * enemy_in_wave
	GameManager.set_total_enemy_size(total_enemy_size)
