extends Control

func _ready() -> void:
	$CenterContainer/VBoxContainer/RetryButton.pressed.connect(_on_retry_pressed)
	$CenterContainer/VBoxContainer/MainMenuButton.pressed.connect(_on_main_menu_pressed)

func _on_retry_pressed() -> void:
	Global.reset_run_state()
	Global.change_scene("res://scenes/main/Game.tscn")

func _on_main_menu_pressed() -> void:
	Global.change_scene("res://scenes/main/MainMenu.tscn")
