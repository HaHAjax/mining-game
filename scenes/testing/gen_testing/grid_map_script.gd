extends GridMap

@onready var blocks_amount_width := Vector3i(1, 1, 1)

@onready var empty_space := Vector3i(8, 4, 8)

@onready var origin_offset := Vector3i(0, 2, 0)

@onready var halved_blocks_amount_width: Vector3i

@onready var halved_empty_space: Vector3i

@onready var surrounding_blocks: Array[Vector3i] = [
		Vector3i(1, 0, 0), Vector3i(-1, 0, 0),
		Vector3i(0, 1, 0), Vector3i(0, -1, 0),
		Vector3i(0, 0, 1), Vector3i(0, 0, -1)
	]


func _ready() -> void:
	# Calculating these once for performance
	halved_blocks_amount_width = Vector3i(ceil(blocks_amount_width.x / 2.0), ceil(blocks_amount_width.y / 2.0), ceil(blocks_amount_width.z / 2.0))
	halved_empty_space = Vector3i(ceil(empty_space.x / 2.0), ceil(empty_space.y / 2.0), ceil(empty_space.z / 2.0))

	# Getting all the possible block positions based on blocks_amount_width and empty_space
	for x in range(-halved_blocks_amount_width.x + -halved_empty_space.x, (halved_blocks_amount_width.x + halved_empty_space.x) + 1):
		for y in range(-halved_blocks_amount_width.y + -halved_empty_space.y, (halved_blocks_amount_width.y + halved_empty_space.y) + 1):
			for z in range(-halved_blocks_amount_width.z + -halved_empty_space.z, (halved_blocks_amount_width.z + halved_empty_space.z) + 1):
				
				# Checking if the block is not inside the empty space
				if abs(x) > halved_empty_space.x or abs(y) > halved_empty_space.y or abs(z) > halved_empty_space.z:

					# For debugging purposes
					# print("placing block at: ", x, " ", y, " ", z)
					
					# Randomly choosing which block to place
					var which_block_to_use: int = randi_range(1, 2)

					# Actually setting the random block
					set_cell_item(Vector3i(x, y, z) + origin_offset, which_block_to_use)
				else:
					set_cell_item(Vector3i(x, y, z) + origin_offset, 0)



func destroy_block(world_coordinate: Vector3) -> void:
	# Making the block coordinate relative to the grid map
	var map_coordinate := local_to_map(world_coordinate)

	# For debugging
	# print("map_coordinate: ", map_coordinate)

	# Destroying the block
	set_cell_item(map_coordinate, 0)


func generate_new_blocks(destroyed_block_position: Vector3i) -> void:
	for offset in surrounding_blocks:
		var temp_block_pos: Vector3i = destroyed_block_position + offset

		# If the block position is an empty space and wasn't the one facing the direction of the side that was destroyed
		if get_cell_item(temp_block_pos) == -1:
			set_cell_item(temp_block_pos, randi_range(1, 2))
