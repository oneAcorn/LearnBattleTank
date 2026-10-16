extends CharacterBody2D

@export var max_speed: float = 300
@onready var engine_sound: AudioStreamPlayer = $EngineSound
@onready var weapon_component: Node2D = $WeaponComponent
@onready var health_component: Node = $HealthComponent
@onready var hurt_box_component: Area2D = $HurtBoxComponent
@onready var camera: Camera2D = $Camera2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var timer: Timer = $Timer

var direction := Vector2.ZERO
var speed: float = 0

var shake_amount := 0.0  # 当前抖动幅度，单位像素
const SHAKE_DECAY := 20.0  # 每秒衰减多少
const SHAKE_MAX := 5.0  # 受击时初始抖动幅度


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.player_win.connect(_on_player_win)


func _process(delta: float) -> void:
	if shake_amount > 0:
		shake_amount = move_toward(shake_amount, 0, SHAKE_DECAY * delta)
		camera.offset = Vector2(randf_range(-shake_amount, shake_amount), randf_range(-shake_amount, shake_amount))
	else:
		camera.offset = Vector2.ZERO


func _physics_process(delta: float) -> void:
	move(delta)


func _unhandled_input(event: InputEvent) -> void:
	var target_pos = get_global_mouse_position()  #获取鼠标的世界坐标
	weapon_component.target(target_pos)
	#print("player unhandled input:%s" % [target_pos])
	if event.is_action_pressed("shoot"):
		#print("player pressed shoot")
		weapon_component.shoot(target_pos)


func move(delta: float):
	direction = Input.get_vector("left", "right", "up", "down")
	if direction != Vector2.ZERO:
		var angle_rad = direction.angle()
		rotation = rotate_toward(rotation, angle_rad, 2 * PI * delta)
		speed = move_toward(speed, max_speed, max_speed * delta)
	else:
		speed = move_toward(speed, 0, 2 * max_speed * delta)
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


func _on_hurt_box_component_get_damage(_damage: float) -> void:
	animation_player.play("flash")
	shake_amount = SHAKE_MAX
