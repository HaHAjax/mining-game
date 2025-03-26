extends GridMap

@onready var blocks_amount_width := Vector3i(1, 1, 1)

@onready var empty_space := Vector3i(8, 4, 8)

@onready var origin_offset := Vector3i(0, 2, 0)


func _ready() -> void:
	var halved_blocks_amount_width := Vector3i(ceil(blocks_amount_width.x / 2.0), ceil(blocks_amount_width.y / 2.0), ceil(blocks_amount_width.z / 2.0))
	var halved_empty_space := Vector3i(ceil(empty_space.x / 2.0), ceil(empty_space.y / 2.0), ceil(empty_space.z / 2.0))

	for x in range(-halved_blocks_amount_width.x + -halved_empty_space.x, (halved_blocks_amount_width.x + halved_empty_space.x) + 1):
		for y in range(-halved_blocks_amount_width.y + -halved_empty_space.y, (halved_blocks_amount_width.y + halved_empty_space.y) + 1):
			for z in range(-halved_blocks_amount_width.z + -halved_empty_space.z, (halved_blocks_amount_width.z + halved_empty_space.z) + 1):
				
				if abs(x) > halved_empty_space.x or abs(y) > halved_empty_space.y or abs(z) > halved_empty_space.z:

					# For debugging purposes
					# print("placing block at: ", x, " ", y, " ", z)
					
					# Random block
					var which_block_to_use: int = randi() % 2

					# Actually set the random block
					set_cell_item(Vector3i(x, y, z) + origin_offset, which_block_to_use)

	# pass
