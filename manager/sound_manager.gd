extends Node

const hover_sound = preload("res://assets/sound/scifi_ui_beep_button_06.ogg")
const click_sound = preload("res://assets/sound/scifi_ui_confirm_upgrade_14.ogg")
@onready var music: AudioStreamPlayer = $Music
@onready var sound: AudioStreamPlayer = $Sound


func play_music():
	music.play()


func stop_music():
	music.stop()


func change_music_vol(value: float):
	music.volume_db = value


func play_click():
	sound.stream = click_sound
	sound.play()


func play_hover():
	sound.stream = hover_sound
	sound.play()
