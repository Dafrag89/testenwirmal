extends CharacterBody2D

signal died

@export var base_move_speed: float = 240.0
@export var max_health: int = 100

var current_health: int = 100
var move_speed: float = 240.0

func _ready() -> void:
	current_health = max_health

func _physics_process(_delta: float) -> void:
	var direction := Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	)
	if direction.length() > 1.0:
		direction = direction.normalized()
	velocity = direction * move_speed
	move_and_slide()

func setup_from_character_data(character_data: Dictionary) -> void:
	move_speed = character_data.get("move_speed", base_move_speed)
	max_health = character_data.get("max_health", max_health)
	current_health = max_health

func take_damage(amount: int) -> void:
	current_health = max(current_health - amount, 0)
	if current_health == 0:
		died.emit()
