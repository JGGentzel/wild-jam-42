extends CharacterBody2D

const knockback_amplifier: float = 2000.0
const knockback_decay_rate: float = .9
var knockback_force: Vector2 = Vector2(0,0)

#const SPEED = 300.0
#const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidDynamicBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta) -> void:
	# Add the gravity.
	#if not is_on_floor():
	#	motion_velocity.y += gravity * delta

	# Handle Jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
	#	motion_velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#var direction = Input.get_axis("ui_left", "ui_right")
	#if direction:
	#	motion_velocity.x = direction * SPEED
	#else:
	#	motion_velocity.x = move_toward(motion_velocity.x, 0, SPEED)
	if knockback_force.length() > .05:
		knockback_force = knockback_force * knockback_decay_rate
		motion_velocity = knockback_force
	else:
		motion_velocity = Vector2(0,0)
	
	move_and_slide()

func on_hit(direction: Vector2, damage: int) -> void:
	print('hit')
	knockback_force = direction * damage * knockback_amplifier
