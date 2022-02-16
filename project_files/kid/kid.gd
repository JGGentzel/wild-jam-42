extends CharacterBody2D

@export var speed: float = 10.0
@export var zip_intensity: float = 3

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_root: Node2D = $root
@onready var sound_effects: AudioStreamPlayer2D = $SoundEffects
@onready var attack_sound = preload("res://audio/attack.wav")
@onready var skate_sound = preload("res://audio/skate.wav")
@onready var board_hit_location: Position2D = $BoardHitLocation
@onready var board_smoke_trail: GPUParticles2D = $root/BoardSmokeTrail

enum States { IDLE, RUNNING, SKATE, ATTACK }
var state: States = States.IDLE
var is_invincible: bool = false
var can_cancel_zip: bool = false
func _ready() -> void:
	animation_player.play('Idle')

func _process(delta: float) -> void:
	var input_vector: Vector2 = get_input()
	match(state):
		States.IDLE:
			animation_player.play('Idle')
		States.RUNNING:
			animation_player.play('Run')
			motion_velocity = input_vector * speed
		States.SKATE:
			animation_player.play('Skate')
			motion_velocity = input_vector * speed * zip_intensity
			if not Input.is_action_pressed('Skate') and can_cancel_zip:
				on_skate_end()
		States.ATTACK:
			animation_player.play('Attack')

func _physics_process(delta: float) -> void:
	move_and_slide()

func get_input() -> Vector2:
	var input_vector: Vector2 = get_input_vector()
	
	if state == States.ATTACK:
		return Vector2.ZERO
		
	if Input.is_action_just_pressed('Skate') and state != States.SKATE:
		sound_effects.stream = skate_sound
		sound_effects.play()
		if input_vector.length() <= 0:
			input_vector = Vector2(1,0) if animation_root.scale.x > 0 else Vector2(-1, 0)
		state = States.SKATE
		is_invincible = true
		board_smoke_trail.emitting = true
	
	elif Input.is_action_just_pressed('Attack') and state != States.SKATE:
		sound_effects.stream = attack_sound
		sound_effects.play()
		state = States.ATTACK
	elif input_vector.length() > 0:
		animation_root.scale = Vector2(1, 1) if motion_velocity.x > 0.01 else Vector2(-1, 1)
		if state != States.SKATE:
			state = States.RUNNING
	else:
		motion_velocity = Vector2.ZERO
		state = States.IDLE

	return input_vector

func get_input_vector() -> Vector2:
	return Vector2(
		Input.get_action_strength('move_right') - Input.get_action_strength('move_left'),
		Input.get_action_strength('move_down') - Input.get_action_strength('move_up')
	).normalized()
	
func create_i_frames(duration: float) -> void:
	is_invincible = true
	var timer: SceneTreeTimer = get_tree().create_timer(duration)
	timer.connect('timeout', on_i_frames_end)

func on_i_frames_end() -> void:
	is_invincible = false

func damage_enemy(body, damage: int) -> void:
	if body.has_method('on_hit') and body.is_in_group('Enemies'):
		var direction = (body.global_position - board_hit_location.global_position).normalized()
		print('attacker_global_position:'+str(board_hit_location.global_position))
		print('body_name:'+str(body.name))
		print('target_global_position:'+str(body.global_position))
		print('attack_direction:'+str(direction))
		print('O===[==-==>')
		body.on_hit(direction, damage)

func on_skate_end() -> void:
	state = States.IDLE
	can_cancel_zip = false
	is_invincible = false
	board_smoke_trail.emitting = false

func on_skate_can_cancel() -> void:
	can_cancel_zip = true

func on_attack_end() -> void:
	state = States.IDLE
	
func _on_board_hit_box_body_entered(body) -> void:
	damage_enemy(body, 1)

func _on_board_attack_area_body_entered(body) -> void:
	damage_enemy(body, 3)






