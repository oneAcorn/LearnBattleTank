extends Control

@onready var start_btn: Button = $TextureRect/MarginContainer/VBoxContainer/StartPanel/Button
@onready var quit_btn: Button = $TextureRect/MarginContainer/VBoxContainer/QuitPanel/Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SoundManager.play_music()
	SoundManager.change_music_vol(0)


func _on_start_btn_pressed() -> void:
	SoundManager.change_music_vol(-20)
	SoundManager.play_click()
	GameManager.to_game()


func _on_quit_btn_pressed() -> void:
	SoundManager.play_click()
	await SoundManager.sound.finished
	get_tree().quit()


func _on_mouse_enter() -> void:
	SoundManager.play_hover()
