extends Node3D

@export var range: float = 6.5
@export var attack_damage: float = 8.0
@export var attack_interval: float = 1.2
@export var projectile_speed: float = 18.0

var _cooldown := 0.0
var _enemies: Array = []

func _ready() -> void:
    add_to_group("towers")

func _process(delta: float) -> void:
    _cooldown = max(_cooldown - delta, 0.0)
    _enemies = _enemies.filter(func(enemy): return is_instance_valid(enemy))

    if _cooldown <= 0.0 and _enemies.size() > 0:
        var target: Node3D = _enemies[0]
        if global_position.distance_to(target.global_position) <= range:
            target.apply_damage(attack_damage)
            _cooldown = attack_interval

func _on_detection_body_entered(body: Node3D) -> void:
    if body.is_in_group("enemies"):
        _enemies.append(body)

func _on_detection_body_exited(body: Node3D) -> void:
    _enemies.erase(body)

func apply_powerup(kind: String) -> void:
    match kind:
        "damage":
            attack_damage *= 2.0
        "speed":
            attack_interval = max(attack_interval * 0.5, 0.2)
