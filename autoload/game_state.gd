extends Node
## The game state manager. [br]
## This script is an autoload that manages specifically only the state of the game.

## The possible states the game can be in.
enum GameStates {
	MAIN_MENU, ## The main menu.
	SETTINGS_MENU, ## The settings menu.
	PLAY, ## When the game is being played.
	PAUSED ## When the game is paused.
}

## The current state the game is in.
var curr_game_state: GameStates = GameStates.MAIN_MENU
## The previous state the game was in.
var prev_game_state: GameStates = GameStates.MAIN_MENU
## The most recent state the game was in.
var last_game_state: GameStates = GameStates.MAIN_MENU


## Emitted when the game state changes.
signal game_state_changed(prev_state: GameStates, curr_state: GameStates)
## Emitted when the game is paused.
signal game_paused
## Emitted when the game is unpaused.
signal game_unpaused


func _ready() -> void:
	# Making sure that the game loop is always active
	self.process_mode = Node.PROCESS_MODE_ALWAYS


func _process(_delta):
	# Check if the game state has changed
	if curr_game_state != prev_game_state:
		# Emit the signal for the game state change
		game_state_changed.emit(prev_game_state, curr_game_state)
		# Set the last game state to the previous game state
		last_game_state = prev_game_state

		match curr_game_state:
			GameStates.MAIN_MENU:
				GameLoop.go_to_main_menu()
			GameStates.SETTINGS_MENU:
				# put the settings menu code here
				pass
			GameStates.PLAY when last_game_state == GameStates.MAIN_MENU:
				GameLoop.start_game()
			GameStates.PLAY when last_game_state == GameStates.PAUSED:
				# Emit the signal for unpausing the game
				game_unpaused.emit()
				# Unpause the game
				GameLoop.resume_game()
			GameStates.PAUSED:
				# Emit the signal for pausing the game
				game_paused.emit()
				# Pause the game
				GameLoop.pause_game()

	prev_game_state = curr_game_state


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") and (curr_game_state == GameStates.PLAY or curr_game_state == GameStates.PAUSED):
		match curr_game_state:
			GameStates.PLAY:
				curr_game_state = GameStates.PAUSED
			GameStates.PAUSED:
				curr_game_state = GameStates.PLAY


## Starts the game.
func start_play_game() -> void:
	curr_game_state = GameStates.PLAY


## Pauses the game.
func pause_game() -> void:
	curr_game_state = GameStates.PAUSED


## Unpauses the game.
func unpause_game() -> void:
	curr_game_state = GameStates.PLAY


## Returns to the main menu.
func to_main_menu() -> void:
	curr_game_state = GameStates.MAIN_MENU


## Shows the settings menu.
func to_settings_menu() -> void:
	curr_game_state = GameStates.SETTINGS_MENU
