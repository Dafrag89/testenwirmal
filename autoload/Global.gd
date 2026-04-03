extends Node

const CHARACTER_DATA_PATH := "res://data/characters"

var selected_character_id: String = "swordsman"
var run_time_seconds: float = 0.0

func reset_run_state() -> void:
	run_time_seconds = 0.0

func change_scene(scene_path: String) -> void:
	get_tree().change_scene_to_file(scene_path)

func load_character_data(character_id: String) -> Dictionary:
	var file_path := "%s/%s.json" % [CHARACTER_DATA_PATH, character_id]
	if not FileAccess.file_exists(file_path):
		return {}

	var file := FileAccess.open(file_path, FileAccess.READ)
	if file == null:
		return {}

	var parsed := JSON.parse_string(file.get_as_text())
	if parsed is Dictionary:
		return parsed
	return {}
