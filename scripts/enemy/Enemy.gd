extends CharacterBody2D

signal died(xp_value: int, world_position: Vector2)

@export var move_speed: float = 80.0
@export var max_health: int = 20
@export var xp_value: int = 5

var current_health: int = 20

func _ready() -> void:
	current_health = max_health

func take_damage(amount: int) -> void:
	current_health = max(current_health - amount, 0)
	if current_health == 0:
		died.emit(xp_value, global_position)
		queue_free()
