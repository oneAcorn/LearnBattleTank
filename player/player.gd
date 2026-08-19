extends Area2D

@export var max_speed: float = 300
@export var bullet_scene: PackedScene
@onready var bullet_marker: Marker2D = $Gun/BulletSpawnMarker
@onready var gun: Sprite2D = $Gun
@onready var collision: CollisionShape2D = $CollisionShape2D

var direction := Vector2.ZERO
var target_pos: Vector2
var speed: float = 0

# 用于边界检测
var half_size := Vector2.ZERO


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if collision:
		var shape = collision.shape
		if shape is CircleShape2D:
			half_size = Vector2(shape.radius, shape.radius)
		elif shape is RectangleShape2D:
			half_size = shape.extents
		elif shape is CapsuleShape2D:
			# 胶囊近似矩形,按矩形处理
			half_size = Vector2(shape.radius, shape.height * 0.5)
		else:
			half_size = shape.get_rect().size * 0.5


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	move(delta)
	target()
	shoot()


func move(delta: float):
	direction = Input.get_vector("left", "right", "up", "down")
	if direction != Vector2.ZERO:
		var angle_rad = direction.angle()
		rotation = rotate_toward(rotation, angle_rad, 2 * PI * delta)
		speed = move_toward(speed, max_speed, max_speed * delta)
	else:
		speed = move_toward(speed, 0, 2 * max_speed * delta)
	position += transform.x * speed * delta
	check_border()


func check_border():
	var size = get_viewport_rect().size
	var min_pos = half_size
	var max_pos = size - half_size
	position = position.clamp(min_pos, max_pos)


func target():
	target_pos = get_global_mouse_position()
	gun.look_at(target_pos)


func shoot():
	if Input.is_action_just_pressed("shoot"):
		var bullet: Node2D = bullet_scene.instantiate()
		bullet.global_position = bullet_marker.global_position
		bullet.look_at(target_pos)
		bullet.top_level = true
		add_child(bullet)
