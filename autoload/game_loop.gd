extends Node

var player_data: PlayerData
var inventory_manager: InventoryManager
var item_database: ItemDatabase
var block_helper: BlockHelper
var inventory_ui_scene := preload("res://scenes/ui/inventory/inventory_ui.tscn")
var inventory_ui: Control
var player: CharacterBody3D

var save_path := "user://player_data.tres"


func _init():
	player_data = PlayerData.new()
	inventory_manager = InventoryManager.new()
	item_database = ItemDatabase.new()
	block_helper = BlockHelper.new()

	item_database.set_block_data()
	block_helper.setup_everything()

	print("Player Data: ", player_data)
	print("Inventory Manager: ", inventory_manager)
	print("Item Database: ", item_database)


func _ready():
	if player_data.inventory.is_empty():
		inventory_manager.set_inventory_from_database()
		player_data.set_inventory_from_manager()
	else:
		inventory_manager.inventory = player_data.inventory
	
	var inventory = inventory_manager.inventory
	print("Inventory: ", inventory)

	player = get_tree().get_root().get_child(1).get_child(1)
	player.hud.add_child(inventory_ui_scene.instantiate())
	inventory_ui = player.get_child(3).get_child(0).get_child(1)

	inventory_manager.set_inventory_ui(inventory_ui)

	# PlayerController.hud.add_child(inventory_ui_scene)

	# # Load player data if it exists
	# var loaded_player_data = load_player_data()
	# if loaded_player_data:
	# 	player_data = loaded_player_data
	# 	inventory_manager.inventory = player_data.inventory
	# 	print("Loaded Player Data: ", player_data)
	# else:
	# 	print("No saved player data found.")


func save_player_data() -> void:
	player_data.inventory = inventory_manager.inventory

	ResourceSaver.save(player_data, save_path)


func load_player_data() -> Resource:
	if ResourceLoader.exists(save_path):
		return load(save_path)
	return null
