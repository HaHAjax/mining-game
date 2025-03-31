extends Resource
class_name PlayerData

var inventory := {}


func _ready():
	pass


func set_inventory_from_manager() -> void:
	var inventory_manager = InventoryManager.new()
	inventory_manager.set_inventory_from_database()
	inventory = inventory_manager.inventory


func get_inventory() -> Dictionary:
	return inventory
