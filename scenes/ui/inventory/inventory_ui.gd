extends Control

var items: Array = []

var inventory_manager: InventoryManager

var item_row_scene := preload("res://scenes/ui/inventory/item_row.tscn")

@onready var container: VBoxContainer = %VBoxContainer


func set_inventory_manager(input_inventory_manager: InventoryManager) -> void:
	inventory_manager = input_inventory_manager


func _ready() -> void:
	inventory_manager = GameLoop.inventory_manager
	for item in inventory_manager.inventory.keys():
		var item_data = inventory_manager.inventory[item]
		if item_data["amount"] == 0:
			return
		var item_row_instance = item_row_scene.instance()
		item_row_instance.set_item_icon(item_data["icon"])
		item_row_instance.set_item_name(item_data["name"])
		item_row_instance.set_item_amount(item_data["amount"])
		add_child(item_row_instance)
		items.append(item_row_instance)


func add_item_visually(item_data: Dictionary) -> void:
	var item_row_instance = item_row_scene.instantiate()
	item_row_instance.set_item_icon(item_data["icon"])
	item_row_instance.set_item_name(item_data["name"])
	item_row_instance.set_item_amount(item_data["amount"])
	item_row_instance.set_item_rarity(item_data["rarity"])
	item_row_instance.name = item_data["name"].to_pascal_case()
	items.append(item_row_instance)
	items.sort_custom(sort_visual_inventory_by_rarity)
	for i in get_child(1).get_children():
		get_child(1).remove_child(i)
	for i in items:
		get_child(1).add_child(i)


func update_item_visually(item_name: String, amount: int) -> void:
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


func sort_visual_inventory_by_rarity(a, b) -> bool:
	if a.item_rarity > b.item_rarity:
		return true
	elif a.item_rarity < b.item_rarity:
		return false
	else:
		return a.name < b.name

	# for i in range(items.size()):
	# 	for j in range(i + 1, items.size()):
	# 		if items[i].item_rarity > items[j].item_rarity:
	# 			var temp = items[i]
	# 			items[i] = items[j]
	# 			items[j] = temp
