extends Control

@onready var killed_label: Label = $MarginContainer/HBoxContainer/PanelContainer/KillCountLabel
@onready var health_bar: ProgressBar = $MarginContainer/HBoxContainer/PanelContainer2/HBoxContainer/HealthBar


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.update_score_ui.connect(on_update_score_Ui)
	GameManager.update_health_ui.connect(on_update_health_ui)
	on_update_score_Ui(GameManager.score, GameManager.enemy_size)


func on_update_health_ui(health: float):
	var value = 100 * health
	health_bar.value = value


func on_update_score_Ui(score: int, total: int):
	killed_label.text = "Killed: %s/%s" % [str(score), str(total)]
