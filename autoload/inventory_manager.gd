extends RefCounted
class_name InventoryManager

var inventory := {}

var inventory_ui: Control


func _ready():
	if inventory.is_empty():
		set_inventory_from_database()


func set_inventory_ui(input_inventory_ui: Control) -> void:
	inventory_ui = input_inventory_ui


func set_inventory_from_database() -> void:
	var item_database = GameLoop.item_database
	for item in item_database.block_data.keys():
			inventory[item] = {
				"uid": item_database.block_data[item]["uid"], # May remove in the future
				"name": item_database.block_data[item]["name"],
				"rarity": item_database.block_data[item]["rarity"], # To categorize it
				"icon": item_database.block_data[item]["item_preview"],
				"amount": 0
			}


func add_item(item_name: String, amount: int = 1) -> void:
	item_name = item_name.to_snake_case()
	if item_name == "air":
		return
	if inventory.has(item_name):
		if inventory[item_name]["amount"] == 0:
			inventory_ui.add_item_visually(inventory[item_name])
		else:
			inventory_ui.update_item_visually(item_name, inventory[item_name]["amount"])
		inventory[item_name]["amount"] += amount
	else:
		print("Item not found in inventory: ", item_name)
