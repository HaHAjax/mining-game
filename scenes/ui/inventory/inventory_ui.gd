extends Control

var items: Array = []

var inventory_manager: InventoryManager

var item_row_scene := preload("res://scenes/ui/inventory/item_row.tscn")

@onready var container: VBoxContainer = %VBoxContainer


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
	item_row_instance.name = item_data["name"].to_pascal_case()
	get_child(1).add_child(item_row_instance)
	items.append(item_row_instance)


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
		

# func _ready():
# 	for item in items:
