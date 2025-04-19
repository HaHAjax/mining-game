extends Control

@onready var play_button: Button = %PlayButton
@onready var quit_button: Button = %SettingsButton


func _play_button_pressed() -> void:
	GameState.start_load_game()

func _settings_button_pressed() -> void:
	GameState.to_settings_menu()
