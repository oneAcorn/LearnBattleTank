extends Node2D

@export var exp_anim_scene: PackedScene
@export var exp_particle_scene: PackedScene
@onready var hit_sound: AudioStreamPlayer2D = $HitSound
@onready var exp_sound: AudioStreamPlayer2D = $ExpSound

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.bullet_hit.connect(on_bullet_hit)
	GameManager.entity_died.connect(on_entity_died)


func expolode(pos: Vector2, name: String):
	var exp_anim: AnimatedSprite2D = exp_anim_scene.instantiate()
	exp_anim.global_position = pos
	add_child(exp_anim)
	exp_anim.play(name)
	exp_sound.global_position = pos
	exp_sound.play()
	await exp_anim.animation_finished
	exp_anim.queue_free()


func spawn_exp_particle(pos: Vector2):
	var exp_particle = exp_particle_scene.instantiate()
	exp_particle.global_position = pos
	add_child(exp_particle)
	exp_particle.emitting = true
	await exp_particle.finished
	exp_particle.queue_free()


func on_entity_died(pos: Vector2, groups: Array):
	if "Enemy" in groups:
		expolode(pos, "regular_explosion")
	elif "Player" in groups:
		expolode(pos, "sonic_explosion")
	elif "EnemyMissile" in groups:
		expolode(pos, "explosion")


func on_bullet_hit(pos: Vector2):
	spawn_exp_particle(pos)
	hit_sound.global_position = pos
	hit_sound.play()
