extends CharacterBody2D

const knockback_amplifier: float = 2000.0
const knockback_decay_rate: float = .9
var knockback_force: Vector2 = Vector2(0,0)

func _physics_process(delta) -> void:
	if knockback_force.length() > .05:
		knockback_force = knockback_force * knockback_decay_rate
		motion_velocity = knockback_force
	else:
		motion_velocity = Vector2(0,0)
	
	move_and_slide()

func on_hit(direction: Vector2, damage: int) -> void:
	print('hit')
	knockback_force = direction * damage * knockback_amplifier
