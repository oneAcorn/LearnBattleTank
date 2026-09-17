extends Node2D

@export var exp_anim_scene: PackedScene
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.enemy_killed.connect(expolode)


func expolode(pos: Vector2):
	var exp_anim: AnimatedSprite2D = exp_anim_scene.instantiate()
	exp_anim.global_position = pos
	add_child(exp_anim)
	exp_anim.play("explosion")
	audio_stream_player.play()
	await exp_anim.animation_finished
	exp_anim.queue_free()
