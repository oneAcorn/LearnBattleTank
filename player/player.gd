extends CharacterBody2D

@export var max_speed: float = 300
@onready var engine_sound: AudioStreamPlayer = $EngineSound
@onready var weapon_component: Node2D = $WeaponComponent
@onready var trail_component: Node2D = $TrailComponent
@onready var health_component: Node = $HealthComponent
@onready var hurt_box_component: Area2D = $HurtBoxComponent
@onready var camera: Camera2D = $Camera2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var timer: Timer = $Timer

var direction := Vector2.ZERO
var speed: float = 0
var can_shake := false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.player_win.connect(_on_player_win)


func _physics_process(delta: float) -> void:
	move(delta)
	if can_shake:
		shake()


func _unhandled_input(event: InputEvent) -> void:
	var target_pos = get_global_mouse_position()  #获取鼠标的世界坐标
	weapon_component.target(target_pos)
	if event.is_action_pressed("shoot"):
		weapon_component.shoot(target_pos)


func move(delta: float):
	direction = Input.get_vector("left", "right", "up", "down")
	if direction != Vector2.ZERO:
		var angle_rad = direction.angle()
		rotation = rotate_toward(rotation, angle_rad, 2 * PI * delta)
		speed = move_toward(speed, max_speed, max_speed * delta)
		trail_component.start()
	else:
		speed = move_toward(speed, 0, 2 * max_speed * delta)
		trail_component.stop()
	velocity = transform.x * speed
	move_and_slide()


func on_player_killed():
	set_process(false)


func _on_health_component_health_changed(health_percent: float) -> void:
	GameManager.update_health_ui.emit(health_percent)


func _on_health_component_died() -> void:
	GameManager.entity_died.emit(global_position, get_groups())
	GameManager.player_killed.emit()
	set_physics_process(false)
	hide()
	hurt_box_component.set_deferred("monitorable", false)


func _on_player_win():
	set_physics_process(false)


func shake():
	camera.offset = Vector2(randf_range(-3, 3), randf_range(-3, 3))


func _on_hurt_box_component_get_damage(damage: float) -> void:
	animation_player.play("flash")
	can_shake = true
	timer.start()


func _on_timer_timeout() -> void:
	can_shake = false
