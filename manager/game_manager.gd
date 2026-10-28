extends Node

signal enemy_killed(pos: Vector2)
signal player_win
signal score_update
signal update_score_ui(score: int, total: int)
signal bullet_hit(pos: Vector2)
signal player_killed
signal update_health_ui(health: float)
signal entity_died(pos: Vector2, groups: Array)  # 单位死亡,触发爆炸

signal level_start

@onready var game_scene: PackedScene = preload("res://game/game.tscn")
@onready var menu_scene: PackedScene = preload("res://UI/menu.tscn")

var score: int = 0
var enemy_size: int = 3  #敌人总数d
var current_level: int = 1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enemy_killed.connect(on_enemy_killed)
	score_update.connect(on_score_update)


func on_enemy_killed(_pos: Vector2):
	score += 1
	if score == enemy_size:
		player_win.emit()


func set_total_enemy_size(size: int):
	enemy_size = size


func on_score_update():
	score += 1
	update_score_ui.emit(score, enemy_size)


func reset_score():
	score = 0


func next_level():
	current_level += 1


func to_menu():
	get_tree().change_scene_to_packed(menu_scene)


func to_game():
	get_tree().change_scene_to_packed(game_scene)


func restart():
	score = 0
	get_tree().reload_current_scene()
