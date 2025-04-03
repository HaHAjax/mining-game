extends RefCounted
class_name InventoryManager

var _inventory := {}

var inventory: Dictionary:
	get:
		return _inventory

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
			"icon": item_database.block_data[item]["item_preview"],
			"rarity": item_database.block_data[item]["rarity"], # To categorize it
			"chance_to_spawn": item_database.block_data[item]["chance_to_spawn"], # To categorize it
			"amount": 0
		}


func load_inventory_visual() -> void:
	if inventory_ui == null:
		print("Inventory UI is null")
		return
	else:
		for item in inventory.keys():
			var item_data = inventory[item]
			if item_data["amount"] == 0:
				return
			inventory_ui.add_item_visually(item_data)


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
	inventory_ui.get_child(1).get_children().sort_custom(inventory_ui.sort_visual_inventory_by_rarity)
	# else:
	# 	print("Item not found in inventory: ", item_name)
