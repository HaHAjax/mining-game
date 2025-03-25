extends GridMap

@onready var blocks_amount_width := Vector3i(1, 1, 1)

@onready var empty_space := Vector3i(32, 32, 32)

@onready var empty_space_offset := Vector3i(0, 0, 0)

func _ready() -> void:
	var halved_blocks_amount_width := Vector3i(ceil(blocks_amount_width.x / 2.0), ceil(blocks_amount_width.y / 2.0), ceil(blocks_amount_width.z / 2.0))
	var halved_empty_space := Vector3i(ceil(empty_space.x / 2.0), ceil(empty_space.y / 2.0), ceil(empty_space.z / 2.0))
	var halved_empty_space_offset := Vector3i(ceil(empty_space_offset.x / 2.0), ceil(empty_space_offset.y / 2.0), ceil(empty_space_offset.z / 2.0))

	for x in range(-halved_blocks_amount_width.x + -halved_empty_space.x, (halved_blocks_amount_width.x + halved_empty_space.x) + 1):
		for y in range(-halved_blocks_amount_width.y + -halved_empty_space.y, (halved_blocks_amount_width.y + halved_empty_space.y) + 1):
			for z in range(-halved_blocks_amount_width.z + -halved_empty_space.z, (halved_blocks_amount_width.z + halved_empty_space.z) + 1):
				
				if (abs(x) > (halved_empty_space.x - halved_empty_space_offset.x)) or (abs(y) > (halved_empty_space.y - halved_empty_space_offset.y)) or (abs(z) > (halved_empty_space.z - halved_empty_space_offset.z)):

					# For debugging purposes
					# print("placing block at: ", x, " ", y, " ", z)
					
					# Random block
					var which_block_to_use: int = randi() % 2

					# Actually set the random block
					set_cell_item(Vector3i(x, y, z), which_block_to_use)

					# continue

				# if x < empty_space_offset.x or x >= blocks_amount_width.x - empty_space_offset.x or y < empty_space_offset.y or y >= blocks_amount_width.y - empty_space_offset.y or z < empty_space_offset.z or z >= blocks_amount_width.z - empty_space_offset.z:
				# 	continue
				
				# print("hello world!")
				
				

				# var block_instance := gen_block_instance()
				# set_cell_item(Vector3i(x, y, z), block_instance)

	# pass
