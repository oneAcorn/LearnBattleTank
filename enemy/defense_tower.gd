extends Area2D

@export var player: Node2D
@export var bullet_scene: PackedScene

@onready var gun: Sprite2D = $Gun
@onready var timer: Timer = $Timer
@onready var bullet_spawn_marker: Marker2D = $Gun/Marker2D


func _ready() -> void:
	timer.start(1)


func _process(delta: float) -> void:
	find_player()


func find_player():
	var player_pos = player.global_position
	gun.look_at(player_pos)


func _on_timer_timeout() -> void:
	shoot()
	timer.start(randf_range(1, 3))


func shoot():
	var bullet: Node2D = bullet_scene.instantiate()
	bullet.global_position = bullet_spawn_marker.global_position
	bullet.rotation = gun.rotation
	bullet.top_level = true  # 脱离父节点影响,防止子弹随炮管旋转而偏移
	add_child(bullet)
