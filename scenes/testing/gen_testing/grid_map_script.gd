extends GridMap

# The amount of blocks to spawn on each side
@onready var blocks_amount_width := Vector3i(1, 1, 1)
# The amount of empty space to spawn in the middle
@onready var empty_space := Vector3i(8, 4, 8)
# The offset that the blocks will spawn from
@onready var origin_offset := Vector3i(0, 2, 0)

# The surrounding blocks, used for generating new blocks (set once so it's not recalculated every time a block is destroyed)
@onready var surrounding_blocks: Array[Vector3i] = [
		Vector3i(1, 0, 0), Vector3i(-1, 0, 0),
		Vector3i(0, 1, 0), Vector3i(0, -1, 0),
		Vector3i(0, 0, 1), Vector3i(0, 0, -1)
	]


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

					# Setting the block to default
					generate_a_block(Vector3i(x, y, z) + origin_offset, false)
				else: # If the block is inside the empty space, set it to air
					generate_a_block(Vector3i(x, y, z) + origin_offset, true)


func destroy_block(world_coordinate: Vector3) -> void:
	# Making the block coordinate relative to the grid map
	var map_coordinate := local_to_map(world_coordinate)

	# For debugging
	# print("map_coordinate: ", map_coordinate)

	# Destroying the block
	generate_a_block(map_coordinate, true)


func generate_new_blocks(destroyed_block_position: Vector3i) -> void:
	# For each surrounding block
	for offset in surrounding_blocks:
		# Getting a single block position (around the destroyed block)
		var temp_block_pos: Vector3i = destroyed_block_position + offset

		# If the temporary block position is actually fully empty,
		if get_cell_item(temp_block_pos) == -1:
			# Place a block there
			generate_a_block(temp_block_pos, false)


func generate_a_block(block_position: Vector3i, is_air: bool) -> void:
	if is_air: # If the block is just air,
		set_cell_item(block_position, 0) # set the block to air;
	else: # otherwise,
		var random_number := randi() % 4 # generate a random number between 0 and 3
		var will_it_be_ore := false if random_number > 0 else true # if the random number is 0, the block will be default; otherwise, it will be ore
		if will_it_be_ore:
			var random_number_generator := RandomNumberGenerator.new() # create a new random number generator
			var which_ore := random_number_generator.rand_weighted([0.5, 0.3, 0.1, 0.1]) + 2 # generate a random number between 0 and 1, weighted towards 0.5
			set_cell_item(block_position, which_ore) # set the block to ore
		else:
			set_cell_item(block_position, 1) # set the block to default

	pass
