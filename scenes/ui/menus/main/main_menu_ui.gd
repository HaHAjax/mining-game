extends Control

@onready var play_button: Button = %PlayButton
@onready var quit_button: Button = %QuitButton


func _play_button_pressed() -> void:
	GameLoop.curr_game_state = GameLoop.GameStates.PLAY

func _quit_button_pressed() -> void:
	GameLoop.quit_game()
