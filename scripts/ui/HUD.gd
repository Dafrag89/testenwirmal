extends Control

func set_character_name(name_text: String) -> void:
	$MarginContainer/VBoxContainer/CharacterLabel.text = "Char: %s" % name_text

func set_run_time(seconds: float) -> void:
	$MarginContainer/VBoxContainer/TimeLabel.text = "Zeit: %.1f" % seconds
