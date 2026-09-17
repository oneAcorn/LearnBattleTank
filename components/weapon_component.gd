extends Node2D

var can_shoot: bool = true
var min_cool_down: float = 0.2

@export var cool_down: float = 0.5
@export var bullet_scene: PackedScene
@onready var muzzle_marker: Marker2D = $Gun/MuzzleMarker
@onready var shoot_sound: AudioStreamPlayer2D = $ShootSound
@onready var timer: Timer = $Timer
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _on_timer_timeout() -> void:
	can_shoot = true


func target(target_pos: Vector2):
	look_at(target_pos)


func shoot(target_pos: Vector2):
	if not can_shoot:
		return
	timer.start(cool_down)
	# 如果冷却时间很短,则缩短开炮动画时长.防止下次开炮时动画没准备好.
	if cool_down < 0.5:
		animation_player.speed_scale = 0.5 / cool_down
	animation_player.play("shoot")
	can_shoot = false
	var bullet: Node2D = bullet_scene.instantiate()
	bullet.global_position = muzzle_marker.global_position
	bullet.look_at(target_pos)
	bullet.top_level = true
	add_child(bullet)


func upgrade(value):
	cool_down = max(min_cool_down, cool_down - value)
