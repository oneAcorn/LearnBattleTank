extends Node

@export var enemy_manager: Node
@export var map_pcg: Node2D

@onready var continue_label: RichTextLabel = $CanvasLayer/Control/ContinuePanel/VBoxContainer/ContinueLabel
@onready var label_anim_player: AnimationPlayer = $CanvasLayer/Control/ContinuePanel/VBoxContainer/AnimationPlayer
@onready var continue_panel: PanelContainer = $CanvasLayer/Control/ContinuePanel
@onready var continue_btn: Button = $CanvasLayer/Control/ContinuePanel/VBoxContainer/ContinueBtn
@onready var control: Control = $CanvasLayer/Control
@onready var timer: Timer = $Timer
@onready var win_panel: PanelContainer = $CanvasLayer/Control/WinPanel
@onready var loss_panel: PanelContainer = $CanvasLayer/Control/LossPanel
@onready var win_btn: Button = $CanvasLayer/Control/WinPanel/VBoxContainer/NextLevelBtn
@onready var loss_btn: Button = $CanvasLayer/Control/LossPanel/VBoxContainer/BackBtn


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.player_killed.connect(_on_player_killed)
	GameManager.player_win.connect(_on_player_win)
	pause_level()
	intro_anim()


func start_level():
	get_tree().paused = false


func pause_level():
	get_tree().paused = true


func intro_anim():
	control.show()
	continue_panel.show()
	win_panel.hide()
	loss_panel.hide()
	set_intro()
	continue_btn.hide()
	label_anim_player.play("show")
	await label_anim_player.animation_finished
	continue_btn.show()


func set_intro():
	var data = enemy_manager.get_enemy_data()
	var text = "[center]Level %s[/center] \n There are %s attack waves and %s enemies." % [GameManager.current_level, data["wave"], data["enemy"]]
	text += "\n kill them all and survive!"
	continue_label.text = text


func _on_player_killed():
	timer.start()
	await timer.timeout
	control.show()
	loss_panel.show()


func _on_player_win():
	timer.start()
	await timer.timeout
	control.show()
	win_panel.show()


func _on_continue_btn_pressed() -> void:
	print("continue btn pressed")
	GameManager.level_start.emit()
	continue_panel.hide()
	control.hide()
	start_level()


func _on_next_level_btn_pressed() -> void:
	GameManager.next_level()
	GameManager.reset_score()
	get_tree().reload_current_scene()


func _on_back_btn_pressed() -> void:
	GameManager.to_menu()
