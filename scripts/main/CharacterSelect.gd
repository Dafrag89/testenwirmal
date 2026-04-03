extends Control

const CHARACTER_IDS := ["swordsman", "archer", "mage"]

func _ready() -> void:
	$MarginContainer/VBoxContainer/HBoxContainer/BackButton.pressed.connect(_on_back_pressed)
	$MarginContainer/VBoxContainer/HBoxContainer/StartRunButton.pressed.connect(_on_start_pressed)

	var list: ItemList = $MarginContainer/VBoxContainer/CharacterList
	for character_id in CHARACTER_IDS:
		list.add_item(character_id.capitalize())
	list.item_selected.connect(_on_character_selected)

	if list.item_count > 0:
		list.select(0)
		_on_character_selected(0)

func _on_back_pressed() -> void:
	Global.change_scene("res://scenes/main/MainMenu.tscn")

func _on_start_pressed() -> void:
	Global.reset_run_state()
	Global.change_scene("res://scenes/main/Game.tscn")

func _on_character_selected(index: int) -> void:
	var character_id: String = CHARACTER_IDS[index]
	Global.selected_character_id = character_id
	var data := Global.load_character_data(character_id)
	var description := "Beschreibung folgt."
	if data.has("description"):
		description = data.description
	$MarginContainer/VBoxContainer/DescriptionLabel.text = description
