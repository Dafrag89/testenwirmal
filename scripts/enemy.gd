extends CharacterBody3D

signal enemy_defeated(enemy: Node3D)
signal goal_reached(enemy: Node3D)

@export var max_health: float = 25.0
@export var move_speed: float = 4.0
@export var reward: int = 6

var _current_health: float
var _path: PackedVector3Array = []
var _path_index := 0

func _ready() -> void:
    _current_health = max_health

func set_path(points: PackedVector3Array) -> void:
    _path = points
    _path_index = 0
    if _path.size() > 0:
        global_position = _path[0]

func _physics_process(delta: float) -> void:
    if _path.is_empty():
        return

    if _path_index >= _path.size():
        goal_reached.emit(self)
        queue_free()
        return

    var target_point := _path[_path_index]
    var direction := (target_point - global_position)
    var distance := direction.length()
    if distance < 0.1:
        _path_index += 1
        return

    direction = direction.normalized()
    velocity = direction * move_speed
    move_and_slide()

func apply_damage(amount: float) -> void:
    _current_health -= amount
    if _current_health <= 0.0:
        enemy_defeated.emit(self)
        queue_free()
