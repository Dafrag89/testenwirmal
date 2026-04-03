extends Control

func _ready() -> void:
	$CenterContainer/VBoxContainer/PlayButton.pressed.connect(_on_play_pressed)
	$CenterContainer/VBoxContainer/OptionsButton.pressed.connect(_on_options_pressed)
	$CenterContainer/VBoxContainer/QuitButton.pressed.connect(_on_quit_pressed)

func _on_play_pressed() -> void:
	Global.change_scene("res://scenes/main/CharacterSelect.tscn")

func _on_options_pressed() -> void:
	Global.change_scene("res://scenes/main/OptionsMenu.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
