extends GridMap

@onready var blocks_amount_width := Vector3i(1, 1, 1)

@onready var empty_space := Vector3i(8, 4, 8)

@onready var origin_offset := Vector3i(0, 2, 0)


func _ready() -> void:
	# Calculating these once for performance
	var halved_blocks_amount_width := Vector3i(ceil(blocks_amount_width.x / 2.0), ceil(blocks_amount_width.y / 2.0), ceil(blocks_amount_width.z / 2.0))
	var halved_empty_space := Vector3i(ceil(empty_space.x / 2.0), ceil(empty_space.y / 2.0), ceil(empty_space.z / 2.0))

	# Getting all the possible block positions based on blocks_amount_width and empty_space
	for x in range(-halved_blocks_amount_width.x + -halved_empty_space.x, (halved_blocks_amount_width.x + halved_empty_space.x) + 1):
		for y in range(-halved_blocks_amount_width.y + -halved_empty_space.y, (halved_blocks_amount_width.y + halved_empty_space.y) + 1):
			for z in range(-halved_blocks_amount_width.z + -halved_empty_space.z, (halved_blocks_amount_width.z + halved_empty_space.z) + 1):
				
				# Checking if the block is not inside the empty space
				if abs(x) > halved_empty_space.x or abs(y) > halved_empty_space.y or abs(z) > halved_empty_space.z:

					# For debugging purposes
					# print("placing block at: ", x, " ", y, " ", z)
					
					# Randomly choosing which block to place
					var which_block_to_use: int = randi() % 2

					# Actually setting the random block
					set_cell_item(Vector3i(x, y, z) + origin_offset, which_block_to_use)


func destroy_block(world_coordinate: Vector3) -> void:
	# Making the block coordinate relative to the grid map
	var map_coordinate := local_to_map(world_coordinate)

	# For debugging
	# print("map_coordinate: ", map_coordinate)

	# Destroying the block
	set_cell_item(map_coordinate, -1)


func generate_new_blocks(destroyed_block_position: Vector3i, face_direction: Vector3i) -> void:
	# # Getting the surrounding blocks
	# var surrounding_blocks: Array[Vector3i] = [
	# 	Vector3i(1, 0, 0),
	# 	Vector3i(-1, 0, 0),
	# 	Vector3i(0, 1, 0),
	# 	Vector3i(0, -1, 0),
	# 	Vector3i(0, 0, 1),
	# 	Vector3i(0, 0, -1)
	# ]

	# # Removing the block in front of the player from the surrounding blocks
	# match face_direction:
	# 	Vector3i(1, 0, 0):
	# 		surrounding_blocks.remove_at(0)
	# 	Vector3i(-1, 0, 0):
	# 		surrounding_blocks.remove_at(1)
	# 	Vector3i(0, 1, 0):
	# 		surrounding_blocks.remove_at(2)
	# 	Vector3i(0, -1, 0):
	# 		surrounding_blocks.remove_at(3)
	# 	Vector3i(0, 0, 1):
	# 		surrounding_blocks.remove_at(4)
	# 	Vector3i(0, 0, -1):
	# 		surrounding_blocks.remove_at(5)
	
	var pass_one_surrounding_blocks := get_valid_surrounding_blocks_pass_one(face_direction)
	var pass_two_surrounding_blocks := get_valid_surrounding_blocks_pass_two(destroyed_block_position, pass_one_surrounding_blocks, face_direction)
	
	# Generate the blocks at the positions
	for block in pass_two_surrounding_blocks:
		set_cell_item(block, randi() % 2)


	
	pass



# Helper functions
func get_valid_surrounding_blocks_pass_one(face_direction: Vector3i) -> Array[Vector3i]:
	var surrounding_blocks: Array[Vector3i] = [
		Vector3i(1, 0, 0),
		Vector3i(-1, 0, 0),
		Vector3i(0, 1, 0),
		Vector3i(0, -1, 0),
		Vector3i(0, 0, 1),
		Vector3i(0, 0, -1)
	]

	for pos in surrounding_blocks:
		if pos == face_direction:
			surrounding_blocks.remove_at(surrounding_blocks.find(pos))
	return surrounding_blocks


func get_valid_surrounding_blocks_pass_two(destroyed_block_position: Vector3i, curr_surrounding_blocks: Array[Vector3i], face_direction: Vector3i) -> Array[Vector3i]:
	var all_existing_blocks: Array[Vector3i] = get_used_cells()

	var valid_surrounding_blocks: Array[Vector3i] = []

	# print(curr_surrounding_blocks)

	for block_from_curr in curr_surrounding_blocks:
		if block_from_curr + destroyed_block_position not in all_existing_blocks and block_from_curr != face_direction:
			valid_surrounding_blocks.append(block_from_curr + destroyed_block_position)

		# if block_from_all == destroyed_block_position + block_from_curr:
		# 	valid_surrounding_blocks.append(block_from_curr + destroyed_block_position)

	return valid_surrounding_blocks
