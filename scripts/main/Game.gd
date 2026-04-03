extends Node2D

@onready var player_spawn: Marker2D = $World/PlayerSpawn
@onready var hud: Control = $CanvasLayer/HUD

func _ready() -> void:
	_spawn_player()
	if hud.has_method("set_character_name"):
		hud.call("set_character_name", Global.selected_character_id.capitalize())

func _process(delta: float) -> void:
	Global.run_time_seconds += delta
	if hud.has_method("set_run_time"):
		hud.call("set_run_time", Global.run_time_seconds)

func _spawn_player() -> void:
	var player_scene := load("res://scenes/player/Player.tscn")
	var player := player_scene.instantiate()
	var character_data := Global.load_character_data(Global.selected_character_id)
	if player.has_method("setup_from_character_data"):
		player.call("setup_from_character_data", character_data)
	player.global_position = player_spawn.global_position
	$World.add_child(player)
	if player.has_signal("died"):
		player.died.connect(_on_player_died)

func _on_player_died() -> void:
	Global.change_scene("res://scenes/main/GameOver.tscn")
