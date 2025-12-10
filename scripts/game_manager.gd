extends Node3D

@export var enemy_scene: PackedScene
@export var tower_scene: PackedScene
@export var powerup_scene: PackedScene
@export var grid_columns: int = 6
@export var grid_rows: int = 3
@export var grid_spacing: float = 3.0
@export var grid_origin: Vector3 = Vector3(-9.0, 0.0, -1.5)
@export var path_node: NodePath = NodePath("EnemyPath")
@export var camera_rig_path: NodePath = NodePath("CameraRig/Camera3D")
@export var lives: int = 10

@onready var _enemy_container: Node3D = $EnemyContainer
@onready var _tower_container: Node3D = $TowerContainer
@onready var _powerup_container: Node3D = $PowerupContainer
@onready var _enemy_path: Path3D = get_node(path_node)
@onready var _camera: Camera3D = get_node(camera_rig_path)

var _grid_slots: Array = []
var _currency: int = 100
var _wave: int = 0
var _path_points: PackedVector3Array
var _rng := RandomNumberGenerator.new()

func _ready() -> void:
    _rng.randomize()
    _generate_slots()
    _path_points = _enemy_path.curve.get_baked_points()
    _start_next_wave()

func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("action_place_unit"):
        _try_place_tower(event.position)

func _generate_slots() -> void:
    _grid_slots.clear()
    for r in range(grid_rows):
        for c in range(grid_columns):
            var pos := grid_origin + Vector3(c * grid_spacing, 0, r * grid_spacing)
            _grid_slots.append(pos)

func _try_place_tower(screen_position: Vector2) -> void:
    var from := _camera.project_ray_origin(screen_position)
    var to := from + _camera.project_ray_normal(screen_position) * 100.0
    var plane := Plane(Vector3.UP, 0.0)
    var hit := plane.intersects_ray(from, to)
    if hit == null:
        return
    var snapped := _snap_to_grid(hit)
    if snapped == null:
        return

    if _tower_container.get_children().any(func(child): return child.global_position.is_equal_approx(snapped)):
        return

    if _currency < 20:
        return

    var tower := tower_scene.instantiate()
    tower.global_position = snapped
    _tower_container.add_child(tower)
    _currency -= 20

func _snap_to_grid(point: Vector3) -> Vector3:
    var nearest := null
    var best_dist := INF
    for slot in _grid_slots:
        var dist := point.distance_squared_to(slot)
        if dist < best_dist:
            best_dist = dist
            nearest = slot
    if nearest == null:
        return null
    if best_dist > (grid_spacing * 0.75) * (grid_spacing * 0.75):
        return null
    return nearest

func _start_next_wave() -> void:
    _wave += 1
    var enemies_in_wave := 5 + _wave * 2
    var delay := 0.8
    for i in range(enemies_in_wave):
        call_deferred("_spawn_enemy_with_delay", i * delay)

func _spawn_enemy_with_delay(delay: float) -> void:
    await get_tree().create_timer(delay).timeout
    _spawn_enemy()

func _spawn_enemy() -> void:
    if enemy_scene == null:
        return
    var enemy := enemy_scene.instantiate()
    enemy.add_to_group("enemies")
    enemy.enemy_defeated.connect(_on_enemy_defeated)
    enemy.goal_reached.connect(_on_enemy_goal)
    enemy.set_path(_path_points)
    _enemy_container.add_child(enemy)

func _on_enemy_defeated(enemy: Node3D) -> void:
    _currency += 5
    if powerup_scene and _rng.randf() < 0.5:
        var powerup := powerup_scene.instantiate()
        powerup.kind = _rng.randi_range(0, 1) == 0 ? "damage" : "speed"
        powerup.global_position = enemy.global_position + Vector3(0, 0.2, 0)
        _powerup_container.add_child(powerup)

    if _enemy_container.get_child_count() <= 1:
        _start_next_wave()

func _on_enemy_goal(enemy: Node3D) -> void:
    lives -= 1
    if lives <= 0:
        get_tree().paused = true
