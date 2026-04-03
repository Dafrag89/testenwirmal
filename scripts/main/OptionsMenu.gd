extends Control

func _ready() -> void:
	$CenterContainer/VBoxContainer/BackButton.pressed.connect(_on_back_pressed)

func _on_back_pressed() -> void:
	Global.change_scene("res://scenes/main/MainMenu.tscn")
