extends Node

signal enemy_killed(pos: Vector2)
signal update_health_ui(health: float)
signal player_killed
signal player_win
signal bullet_hit(pos: Vector2)
signal entity_died(pos: Vector2, groups: Array)  # 单位死亡,触发爆炸
signal score_update
signal update_score_ui(score: int, total: int)

var score: int = 0
var enemy_size: int = 3  #敌人总数


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enemy_killed.connect(on_enemy_killed)
	score_update.connect(on_score_update)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func on_enemy_killed(pos: Vector2):
	score += 1
	if score == enemy_size:
		player_win.emit()


func set_total_enemy_size(size: int):
	enemy_size = size


func on_score_update():
	score += 1
	update_score_ui.emit(score, enemy_size)


func restart():
	score = 0
	get_tree().reload_current_scene()
