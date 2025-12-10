extends Area3D

@export var kind: String = "damage"
@export var magnet_speed: float = 10.0

func _ready() -> void:
    monitoring = false

func _physics_process(delta: float) -> void:
    var towers := get_tree().get_nodes_in_group("towers")
    towers = towers.filter(func(t): return is_instance_valid(t))
    if towers.is_empty():
        return

    var closest := towers[0]
    var closest_dist := global_position.distance_to(closest.global_position)
    for tower in towers:
        var dist := global_position.distance_to(tower.global_position)
        if dist < closest_dist:
            closest = tower
            closest_dist = dist

    var direction := (closest.global_position - global_position).normalized()
    global_position += direction * magnet_speed * delta

    if closest_dist < 0.8:
        closest.apply_powerup(kind)
        queue_free()
