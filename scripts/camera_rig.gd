extends Node3D

@export var orbit_radius: float = 16.0
@export var height: float = 10.0
@export var rotation_speed: float = 1.8
@onready var pivot: Node3D = self
@onready var camera: Camera3D = $Camera3D

func _ready() -> void:
    _update_camera_position()

func _process(delta: float) -> void:
    var rotate_input := 0.0
    if Input.is_action_pressed("action_rotate_left"):
        rotate_input -= 1.0
    if Input.is_action_pressed("action_rotate_right"):
        rotate_input += 1.0

    if abs(rotate_input) > 0.0:
        rotation.y += rotate_input * rotation_speed * delta
        _update_camera_position()

func _update_camera_position() -> void:
    var target := Vector3.ZERO
    var x := cos(rotation.y) * orbit_radius
    var z := sin(rotation.y) * orbit_radius
    camera.transform.origin = Vector3(x, height, z)
    camera.look_at(target, Vector3.UP)
