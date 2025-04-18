extends RefCounted
class_name InventoryManager
## The inventory manager script. [br]
## This script handles the inventory of the player behind the scenes. [br]
## Used for only the backend of the inventory, not the visual part.

## The private inventory variable [br]
## This should only be used inside the inventory manager. [br]
## Use instead: [member inventory]
var _inventory := {}

## The accessible inventory of the player. [br]
## This is a dictionary of dictionaries, where the key is the item name and the value is a dictionary of the item data. [br]
## The item data dictionary contains the following keys: [br]
## - [param uid]: The unique id of the item. [br]
## - [param name]: The name of the item. [br]
## - [param icon]: The icon of the item. [br]
## - [param rarity]: The rarity of the item. [br]
## - [param chance_to_spawn]: The chance to spawn the item. [br]
## - [param amount]: The amount of the item. [br]
var inventory: Dictionary:
	get:
		return _inventory

## The inventory UI variable, used to update the visual inventory. [br]
## @deprecated: Don't use this. Should switch to [SingletonManager.inventory_ui] instead, when that's added.
var inventory_ui: Control


func _ready():
	if inventory.is_empty():
		set_inventory_from_database()


## Sets the [member inventory_ui] variable to the [param input_inventory_ui] variable. [br]
## @deprecated: Don't use this. Should switch to [SingletonManager.inventory_ui] instead, when that's added.
func set_inventory_ui(input_inventory_ui: Control) -> void:
	inventory_ui = input_inventory_ui


## Sets the inventory from the database. [br]
## Use this only if the player has absolutely NO data. [br]
## Sets the amount to 0 for all items.
func set_inventory_from_database() -> void:
	var item_database = GameLoop.item_database
	for item in item_database.block_data.keys():
		inventory[item] = {
			"uid": item_database.block_data[item]["uid"], # May remove in the future
			"name": item_database.block_data[item]["name"],
			"icon": item_database.block_data[item]["item_preview"],
			"rarity": item_database.block_data[item]["rarity"], # To categorize it
			"chance_to_spawn": item_database.block_data[item]["chance_to_spawn"], # To categorize it
			"amount": 0
		}


## Loads the visual inventory for every item that the player has more than 0 of.
func load_inventory_visual() -> void:
	if inventory_ui == null:
		print("Inventory UI is null")
		return
	else:
		for item in inventory.keys():
			var item_data = inventory[item]
			if item_data["amount"] == 0:
				continue
			inventory_ui.add_item_visually(item_data)


## Adds an item to the inventory. [br]
## @experimental: Might need to be optimized.
func add_item(item_name: String, amount: int = 1) -> void:
	item_name = item_name.to_snake_case()
	if item_name == "air":
		return
	if inventory.has(item_name):
		inventory[item_name]["amount"] += amount
		if inventory[item_name]["amount"] == 1:
			inventory_ui.add_item_visually(inventory[item_name])
		else:
			inventory_ui.update_item_visually(item_name, inventory[item_name]["amount"])
