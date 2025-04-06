extends Node

# Stuff to make this a singleton
static var ref: AutoloadManager
func _init() -> void:
	if not ref: ref = self
	# else: queue_free()
	
	player_data = load_player_data()

var save_path := "user://player_data.tres"

@onready var game_loop: Node = get_node("/root/GameLoop")
@onready var player_data: PlayerData
@onready var inventory_manager := InventoryManager.new()
@onready var item_database := ItemDatabase.new()
@onready var block_helper := BlockHelper.new()
@onready var player: CharacterBody3D
@onready var grid_map_script: GridMapScript

var block_spawn_chances: Array[float]


func _ready():
	if load_player_data() != null:
		player_data = load_player_data()
	else:
		player_data = PlayerData.new()
		player_data.inventory = inventory_manager.inventory
	
	for block_chance in item_database.block_data.values():
		block_spawn_chances.append(block_chance["chance_to_spawn"])
	grid_map_script = get_tree().get_root().find_child("GridMap", true, false) as GridMapScript
	grid_map_script.set_weights(block_spawn_chances)
	# print("from autoload_manager: ", grid_map_script)

	game_loop.set_variables(player_data, inventory_manager, item_database, block_helper)


func set_player(input_player: CharacterBody3D) -> void:
	player = input_player


func setup_everything() -> void:
	block_helper.setup_everything()
	item_database.set_block_data()
	inventory_manager.set_inventory_from_database()
	player_data.set_inventory_from_manager()
	game_loop.inventory_ui.set_inventory_manager(inventory_manager)
	for block_chance in item_database.block_data.values():
		if block_chance["type"] != 0 and block_chance["type"] != 1:
			block_spawn_chances.append(block_chance["chance_to_spawn"])
	grid_map_script = get_tree().get_root().find_child("GenAndMineTesting", true, false).find_child("GridMap", true, false) as GridMapScript
	grid_map_script.set_weights(block_spawn_chances)
	# print("from autoload_manager: ", grid_map_script)
	grid_map_script.generate_initial_blocks()


func save_player_data() -> void:
	player_data.inventory = inventory_manager.inventory
	# print(player_data.inventory)
	ResourceSaver.save(player_data, save_path)


func load_player_data() -> PlayerData:
	if ResourceLoader.exists(save_path):
		return load(save_path)
	return null


func load_game() -> void:
	var loaded_player_data = load_player_data()
	if loaded_player_data:
		player_data = loaded_player_data
		inventory_manager.inventory = player_data.inventory
		# print("Loaded Player Data: ", player_data)
	else:
		# print("No saved player data found.")
		pass
