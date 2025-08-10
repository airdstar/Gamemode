extends Node
class_name Health

@export var max : int = 100
@export var amount : int = 100

signal health_changed

func damage(damage : int) -> void:
	if is_multiplayer_authority():
		amount -= damage
	health_changed.emit(amount)
	if amount <= 0:
		get_parent().death()

func heal(heal : int) -> void:
	if is_multiplayer_authority():
		amount += heal
		if amount > max:
			amount = max
	health_changed.emit(amount)
