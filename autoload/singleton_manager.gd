extends Node
## The singleton manager. [br]
## Essentially just an autoload script that handles all of the resources the game will use.

## DO NOT USE THIS
## @deprecated: This constant is a remnant of the old solution for the player save data
const SAVE_PATH := "user://player_data.tres"

## The game loop singleton.
## @deprecated: just use [GameLoop] instead, no idea why I added this
@onready var game_loop: Node = get_node("/root/GameLoop")
## The player data script. [br]
## Holds all of the player's data, such as inventory, gear, etc. [br]
## Only holds the player data while running, should NOT be used as player data storage.
@onready var player_data: PlayerData
## The inventory manager script, only made here to essentially make it a singleton.
@onready var inventory_manager := InventoryManager.new()
## The item database script, only made here to essentially make it a singleton.
@onready var item_database := ItemDatabase.new()
## The block helper script, only made here to essentially make it a singleton.
@onready var block_helper := BlockHelper.new()
## The player scene.
## @deprecated: Use [member GameLoop.player] instead.
@onready var player: CharacterBody3D
## The grid map script. Should already exist, so it doesn't need to be instantiated.
@onready var grid_map_script: GridMapScript

## All of the block spawn chances, just for the grid_map_script.
var block_spawn_chances: Array[float]

signal everything_set_up


func _ready():
	# Temporary. Will use a different approach in the future.
	# Just here so things don't break instantly.
	player_data = PlayerData.new()
	
	# Set the inventory manager's inventory to the saved player data's inventory
	inventory_manager.inventory = player_data.inventory

	# Setting the variables for the game loop
	# Remove this later, these variables should instead be referenced from this script, not the GameLoop script
	game_loop.set_variables(player_data, inventory_manager, item_database, block_helper)


## Set the player variable to the [param input_player].
func set_player(input_player: CharacterBody3D) -> void:
	player = input_player


## Sets up everything necesary for the game to run.
func setup_everything() -> void:
	block_helper.setup_everything()
	item_database.set_block_data()
	inventory_manager.set_inventory_from_database()
	player_data.set_inventory_from_manager()
	for block_chance in item_database.block_data.values():
		if block_chance["type"] > 1:
			block_spawn_chances.append(block_chance["chance_to_spawn"])
	grid_map_script = get_tree().get_root().find_child("GridMap", true, false) as GridMapScript
	if grid_map_script == null:
		return
	grid_map_script.set_weights(block_spawn_chances)
	# print("from autoload_manager: ", grid_map_script)
	grid_map_script.generate_initial_blocks()

	everything_set_up.emit()


## The function that will save the player's data.
## @experimental: This function is not yet implemented.
func save_player_data() -> void:
	print("TODO: save player data")
