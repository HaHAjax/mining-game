extends ScrollContainer

var items: Array = []

var inventory_manager: InventoryManager

var item_row_scene := preload("res://scenes/ui/inventory/item_row.tscn")

@onready var container: VBoxContainer = %VBoxContainer


func _ready() -> void:
	# Getting the inventory manager from the game loop
	inventory_manager = GameLoop.inventory_manager

	# All this is for if the player has some items stored in the player data
	# Currently, there is no player data, so this may or may not actually work
	for item in inventory_manager.inventory.keys():
		var item_data = inventory_manager.inventory[item]
		if item_data["amount"] == 0:
			continue
		var item_row_instance = item_row_scene.instantiate()
		item_row_instance.set_item_icon(item_data["icon"])
		item_row_instance.set_item_name(item_data["name"])
		item_row_instance.set_item_amount(item_data["amount"])
		add_child(item_row_instance)
		items.append(item_row_instance)


## Adding an item visually [br]
## This function is called when an item is added to the inventory for the first time
func add_item_visually(item_data: Dictionary) -> void:
	# Instantiating the item row scene
	var item_row_instance = item_row_scene.instantiate()

	# Setting the item data
	item_row_instance.set_item_icon(item_data["icon"])
	item_row_instance.set_item_name(item_data["name"])
	item_row_instance.set_item_amount(item_data["amount"])
	item_row_instance.set_item_rarity(item_data["rarity"])
	item_row_instance.set_item_chance_to_spawn(item_data["chance_to_spawn"])
	item_row_instance.name = item_data["name"].to_pascal_case()

	# Adding the item row instance to the items array
	items.append(item_row_instance)

	# Sorting the items array
	items.sort_custom(_sort_visual_inventory_by_rarity)

	# Removing all visual items
	for i in get_child(0).get_children():
		get_child(0).remove_child(i)
	
	# Adding the sorted items back to the visual inventory
	for i in items:
		get_child(0).add_child(i)


## Updating the item visually [br]
## SHould only be called when the item is already in the inventory, but the amount is changed
func update_item_visually(item_name: String, amount: int) -> void:
	# Formatting the item name to snake case
	item_name = item_name.to_snake_case()


	var item_index: int = -1
	for i in range(items.size()):
		if items[i].name == item_name.to_pascal_case():
			item_index = i
			break
		else:
			item_index = -1
	if item_index != -1:
		items[item_index].set_item_amount(amount)
	else:
		print("Item not found in inventory: ", item_name)


# The callable to sort the visual inventory by rarity
# It SHOULD only be used when an item is added for the first time
func _sort_visual_inventory_by_rarity(a, b) -> bool:
	if a.item_rarity > b.item_rarity:
		return true
	elif a.item_rarity < b.item_rarity:
		return false
	else:
		return a.item_chance_to_spawn > b.item_chance_to_spawn
