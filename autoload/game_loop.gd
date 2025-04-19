extends Node

## The player data singleton.
## @experimental: This may or may not actually be used, and may or may not even be used.
var player_data: PlayerData
## The inventory manager singleton.
## @deprecated: Use the variable from the SingletonManager instead.
var inventory_manager: InventoryManager
## The item database singleton.
## @deprecated: Use the variable from the SingletonManager instead.
var item_database: ItemDatabase
## The block helper singleton.
## @deprecated: Use the variable from the SingletonManager instead.
var block_helper: BlockHelper
## The inventory UI scene, as a PackedScene.
var inventory_ui_scene := preload("res://scenes/ui/inventory/inventory_ui.tscn")
## The inventory UI instance. Will be instantiated on game start.
var inventory_ui: ScrollContainer
## The player scene, as a PackedScene.
var player_scene := preload("res://scenes/player/player.tscn")
## The actual player scene instance.
var player: CharacterBody3D

## The save path for the player data.
## @deprecated: A different approach will be used in the future. Avoid using this.
const SAVE_PATH := "user://player_data.tres"

## The instantiated pause menu scene, to be used when the game is paused.
var pause_menu: Control

## The main menu UI scene, as a PackedScene.
const MAIN_MENU_UI := preload("res://scenes/ui/menus/main/main_menu_ui.tscn")
## The pause menu UI scene, as a PackedScene.
const PAUSE_MENU_UI := preload("res://scenes/ui/pause/pause_menu.tscn")
## The scene for the main scene, as a PackedScene.
## @deprecated: Use this only for testing.
const GEN_AND_MINE_TESTING := preload("res://scenes/testing/gen_testing/gen_and_mine_testing.tscn")

const MAIN_SCENE := preload("res://scenes/main.tscn")

const GRID_MAP_SCENE := preload("res://scenes/misc/grid_map_scene.tscn")

var grid_map_scene_instance: GridMap

var main_scene_instance: Node3D

const LOADING_SCREEN := preload("res://scenes/ui/loading/loading_screen.tscn")

var loading_screen_instance: LoadingScreenScript


func _init():
	pass


func _ready():
	# Making sure that the game loop is always active
	self.process_mode = Node.PROCESS_MODE_ALWAYS

	# Instantiates the pause menu UI
	pause_menu = PAUSE_MENU_UI.instantiate()

	# Adds the pause menu to the scene tree
	get_tree().get_root().add_child.call_deferred(pause_menu)

	# Hides the pause menu, as it should not be active just yet
	pause_menu.hide()


## Sets the variables for the game loop.
func set_variables(input_player_data: PlayerData, input_inventory_manager: InventoryManager, input_item_database: ItemDatabase, input_block_helper: BlockHelper) -> void:
	player_data = input_player_data
	inventory_manager = input_inventory_manager
	item_database = input_item_database
	block_helper = input_block_helper

	# inventory_manager.set_inventory_ui(inventory_ui)
	# inventory_manager.load_inventory_visual()


## Pauses the game
func pause_game() -> void:
	# Pause the game
	get_tree().paused = true
	# Show the pause menu
	pause_menu.show()


## Resumes the game from the pause menu.
func resume_game() -> void:
	# Unpause the game
	get_tree().paused = false
	# Hide the pause menu
	pause_menu.hide()


func load_game() -> void:
	# # Unloads the main menu
	get_tree().get_root().find_child("MainMenu", true, false).queue_free()

	loading_screen_instance = LOADING_SCREEN.instantiate()
	
	get_tree().get_root().add_child(loading_screen_instance)

	loading_screen_instance.set_next_scene(GRID_MAP_SCENE.resource_path)


	start_game()


## Starts the game
func start_game() -> void:
	# grid_map_scene_instance = await loading_screen_instance.loading_complete
	# Instantiates the grid map scene into the scene tree
	get_tree().get_root().add_child(await loading_screen_instance.loading_complete)

	loading_screen_instance.set_next_scene(MAIN_SCENE.resource_path)

	get_tree().get_root().add_child(await loading_screen_instance.loading_complete)

	# # Instantiates the main scene
	# main_scene_instance = MAIN_SCENE.instantiate()

	# # Adds the main scene to the scene tree
	# get_tree().get_root().add_child(main_scene_instance)

	# Instantiates the player
	player = player_scene.instantiate()
	player.position.y += 1.1 # Offset the player to be above the ground

	# Adds the player to the scene tree
	get_tree().get_root().find_child("Main", true, false).add_child(player)

	# Instantiates the inventory UI
	inventory_ui = inventory_ui_scene.instantiate()

	# Sets up all things necessary for the SingletonManager
	SingletonManager.setup_everything()

	# Gives the inventory manager the proper inventory UI instance
	inventory_manager.set_inventory_ui(inventory_ui)
	
	# Adds the inventory UI as a child of the player scene
	get_tree().get_root().find_child("Player", true, false).find_child("Control", true, false).add_child(inventory_ui)

	# Loads the visuals for the inventory UI
	inventory_manager.load_inventory_visual()

	# Moves the pause menu to the front, so that it can be interacted with
	pause_menu.move_to_front()

	loading_screen_instance.queue_free()

	GameState.curr_game_state = GameState.GameStates.PLAY


## The private quit game function. [br]
## Should only be called inside the GameLoop script.
## @deprecated: This game will run in web browsers, so quitting should not be possible.
func _quit_game() -> void:
	# Save player_scene data when quitting the game
	SingletonManager.save_player_data()
	print("Player data saved.")
	get_tree().quit()


## Tells the game loop to quit the game.
## @deprecated: This game will run in web browsers, so quitting should not be possible.
func input_quit() -> void:
	_quit_game()


## Makes the game go back to the main menu. [br]
## Should only be called when the game is not in the main menu, and has not just started.
func go_to_main_menu() -> void:
	SingletonManager.save_player_data()
	print("Player data saved.")
	get_tree().get_root().find_child("GenAndMineTesting", true, false).queue_free()
	get_tree().get_root().add_child(MAIN_MENU_UI.instantiate())
