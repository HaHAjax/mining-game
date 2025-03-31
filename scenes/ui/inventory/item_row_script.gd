extends HBoxContainer

@export var item_icon: TextureRect
@export var item_name: Label
@export var item_amount: Label

func set_item_icon(icon: Texture) -> void:
	if item_icon == null:
		push_error("Item icon is null")
		return
	item_icon.texture = icon

func set_item_name(input_item_name: String) -> void:
	if item_name == null:
		push_error("Item name is null")
		return
	item_name.text = input_item_name

func set_item_amount(amount: int) -> void:
	if item_amount == null:
		push_error("Item amount is null")
		return
	item_amount.text = str(amount)
