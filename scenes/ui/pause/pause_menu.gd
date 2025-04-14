extends Control


func _on_quit_pressed():
	GameLoop.input_quit()


func _on_main_menu_pressed():
	GameLoop.go_to_main_menu()


func _on_resume_pressed():
	GameLoop.input_resume_game()
