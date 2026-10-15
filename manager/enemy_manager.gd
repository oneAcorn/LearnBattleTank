extends Node

signal wave_died

@export var enemy_tank_scene: PackedScene
var died_tank: int
var died_enemy: int
var total_enemy_size: int

@export var path_holder: Node2D
@export var wave_number: int = 3  # 敌方攻击波次数量
@export var enemy_in_wave: int = 8  # 每个波次的坦克数量
@export var enemy_spawn_time: int = 2  # 敌人出生时间间隔
@export var enemies_holder: Node2D  # 敌人节点容器
@onready var paths: Array


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.entity_died.connect(on_entity_died)
	check_enemy_size()
	paths = path_holder.get_children()
	spawn_waves()


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
	var enemy_tank = enemy_tank_scene.instantiate()
	var path = paths.pick_random()
	enemy_tank.speed = randi_range(100, 150)
	path.add_child(enemy_tank)


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
