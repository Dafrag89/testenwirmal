extends Node

signal level_up(new_level: int)

var current_level: int = 1
var current_xp: int = 0

func add_xp(amount: int) -> void:
	current_xp += amount
	if current_xp >= _xp_to_next_level():
		current_xp = 0
		current_level += 1
		level_up.emit(current_level)

func _xp_to_next_level() -> int:
	return 10 + (current_level - 1) * 5
