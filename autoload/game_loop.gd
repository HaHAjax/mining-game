extends Node

var player_data: PlayerData
var inventory_manager: InventoryManager
var item_database: ItemDatabase
var block_helper: BlockHelper
var inventory_ui_scene := preload("res://scenes/ui/inventory/inventory_ui.tscn")
var inventory_ui: Control
var player_scene := preload("res://scenes/player/player.tscn")
var player: CharacterBody3D

var save_path := "user://player_data.tres"


var other: AutoloadManager


func _init():
	

	# player_data = PlayerData.instance
	# inventory_manager = InventoryManager.new()
	# item_database = ItemDatabase.new()
	# block_helper = BlockHelper.new()

	# block_helper.setup_everything()
	# item_database.set_block_data()
	pass

	# print("Player Data: ", player_data)
	# print("Inventory Manager: ", inventory_manager)
	# print("Item Database: ", item_database)


func _ready():
	other = AutoloadManager.ref

	other._ready()


	# var inventory = inventory_manager.inventory
	# print("Inventory: ", inventory)

	# player_scene = get_tree().get_root().get_child(1).get_child(1)
	# player_scene.hud.add_child(inventory_ui_scene.instantiate())
	# inventory_ui = player_scene.get_child(3).get_child(0).get_child(1)

	# inventory_manager.set_inventory_ui(inventory_ui)
	pass

	# inventory_manager.set_inventory_ui(inventory_ui)

	# inventory_manager.load_inventory_visual()

	# PlayerController.hud.add_child(inventory_ui_scene)

	# # Load player_scene data if it exists
	# var loaded_player_data = load_player_data()
	# if loaded_player_data:
	# 	player_data = loaded_player_data
	# 	inventory_manager.inventory = player_data.inventory
	# 	print("Loaded Player Data: ", player_data)
	# else:
	# 	print("No saved player_scene data found.")


func set_variables(input_player_data: PlayerData, input_inventory_manager: InventoryManager, input_item_database: ItemDatabase, input_block_helper: BlockHelper) -> void:
	player_data = input_player_data
	inventory_manager = input_inventory_manager
	item_database = input_item_database
	block_helper = input_block_helper

	# inventory_manager.set_inventory_ui(inventory_ui)
	# inventory_manager.load_inventory_visual()


func start_game() -> void:
	get_tree().get_root().find_child("MainMenu", true, false).queue_free()
	# print(get_tree().get_root().find_child("MainMenu", true, false))
	get_tree().get_root().add_child(load("res://scenes/testing/gen_testing/gen_and_mine_testing.tscn").instantiate())

	player = player_scene.instantiate()
	player.position.y += 1.1


	get_tree().get_root().find_child("GenAndMineTesting", true, false).add_child(player)

	inventory_ui = inventory_ui_scene.instantiate()

	other.setup_everything()
	
	get_tree().get_root().find_child("Player", true, false).find_child("Control", true, false).add_child(inventory_ui)

	# inventory_manager.set_inventory_ui(inventory_ui)

	# get_tree().get_root().add_child()

	if other.load_player_data() != null:
		player_data = other.load_player_data()
		# print("Player data not null: ", player_data.inventory)
	# print(player_data.inventory)
	if player_data.inventory.is_empty():
		# print("Player data inventory is empty")
		if inventory_manager.inventory.is_empty():
			# print("Inventory manager inventory is empty")
			inventory_manager.set_inventory_from_database()
		player_data.set_inventory_from_manager()
	else:
		# print("Player data inventory is not empty")
		inventory_manager.inventory = player_data.inventory

	inventory_ui.set_inventory_manager(inventory_manager)

	inventory_manager.set_inventory_ui(inventory_ui)
	inventory_manager.load_inventory_visual()


func quit_game() -> void:
	# Save player_scene data when quitting the game
	other.save_player_data()
	print("Player data saved.")
	get_tree().quit()


func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		# Save player_scene data when the game is closed
		other.save_player_data()
		print("Player data saved.")
