extends Node

@export var gun_pickup_scene: PackedScene
@export var health_pickup_scene: PackedScene
@onready var pickup_array = [gun_pickup_scene, health_pickup_scene]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.entity_died.connect(on_entity_died)


func on_entity_died(pos: Vector2, groups: Array):
	if "Enemy" in groups:
		if randi_range(1, 10) > 5:
			call_deferred("spawn_pickup", pos)


func spawn_pickup(pos: Vector2):
	var pickup_scene: PackedScene = pickup_array.pick_random()
	var pickup: Area2D = pickup_scene.instantiate()
	pickup.global_position = pos
	add_child(pickup)
