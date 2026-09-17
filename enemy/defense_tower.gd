extends Area2D

@export var bullet_scene: PackedScene
@export var health: int = 3

@onready var player: Node2D = get_tree().get_first_node_in_group("Player")
@onready var gun: Sprite2D = $Gun
@onready var timer: Timer = $Timer
@onready var bullet_spawn_marker: Marker2D = $Gun/Marker2D


func _ready() -> void:
	timer.start(1)
	GameManager.player_killed.connect(on_player_killed)


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


func reduce_health():
	if health > 0:
		health -= 1
	if health <= 0:
		GameManager.enemy_killed.emit(global_position)
		queue_free()


func on_player_killed():
	timer.stop()
