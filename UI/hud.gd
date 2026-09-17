extends Control

@onready var killed_label: Label = $MarginContainer/HBoxContainer/PanelContainer/KillCountLabel
@onready var health_bar: ProgressBar = $MarginContainer/HBoxContainer/PanelContainer2/HBoxContainer/HealthBar
@onready var timer = $Timer
@onready var notify_panel = $MarginContainer/NotifyPanel
@onready var notify_label = $MarginContainer/NotifyPanel/NotifyLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.enemy_killed.connect(on_enemy_killed)
	GameManager.update_health_ui.connect(on_update_health_ui)
	GameManager.player_killed.connect(on_player_killed)
	GameManager.player_win.connect(on_player_win)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func on_enemy_killed(pos: Vector2):
	killed_label.text = "Killed: %s" % str(GameManager.score)


func on_update_health_ui(health: int):
	var value = 100 * health / 10
	health_bar.value = value


func on_player_killed():
	timer.start()
	await timer.timeout
	notify_label.text = "You Lost"
	notify_panel.show()


func on_player_win():
	timer.start()
	await timer.timeout
	notify_label.text = "You Win"
	notify_panel.show()
