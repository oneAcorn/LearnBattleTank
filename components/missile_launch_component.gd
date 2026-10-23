extends Node2D

var can_shoot: bool = true
var min_cool_down: float = 0.2

@export var cool_down: float = 0.5
@export var missile_scene: PackedScene
@onready var marker1: Marker2D = $Sprite2D/Marker2D
@onready var marker2: Marker2D = $Sprite2D/Marker2D2
@onready var shoot_sound: AudioStreamPlayer2D = $ShootSound
@onready var timer: Timer = $Timer
@onready var launch_pos: Array = [marker1, marker2]


func target(target_pos: Vector2):
	look_at(target_pos)


func shoot(target_pos: Vector2):
	if can_shoot:
		print("missile shoot")
		timer.start(cool_down)
		shoot_sound.play()
		can_shoot = false
		var missile: Node2D = missile_scene.instantiate()
		missile.global_position = launch_pos.pick_random().global_position
		missile.look_at(target_pos)
		#missile.top_level = true
		#add_child(missile)
		get_tree().current_scene.add_child(missile)


func upgrade(value: float):
	cool_down = max(min_cool_down, cool_down - value)


func _on_timer_timeout() -> void:
	can_shoot = true
