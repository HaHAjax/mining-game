extends Control


func _on_settings_pressed():
	GameState.to_settings_menu()


func _on_main_menu_pressed():
	GameState.to_main_menu()


func _on_resume_pressed():
	GameState.unpause_game()
