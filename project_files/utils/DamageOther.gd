extends Node

class_name DamageOther

func damage_other(body: CharacterBody2D, position_emit_from: Vector2, damage: int) -> void:
	if body.has_method('on_hit') and body.is_in_group('Enemies'):
		var direction = (body.global_position - position_emit_from).normalized()
		print('attacker_global_position:'+str(position_emit_from))
		print('body_name:'+str(body.name))
		print('target_global_position:'+str(body.global_position))
		print('attack_direction:'+str(direction))
		print('O===[==-==>')
		body.on_hit(direction, damage)
