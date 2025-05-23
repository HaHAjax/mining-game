extends GridMap
class_name GridMapScript

@onready var block_helper := load("res://resources/block_data/block_helper.gd")

# The amount of blocks to spawn on each side
@onready var blocks_amount_width := Vector3i(1, 1, 1)
# The amount of empty space to spawn in the middle
@onready var empty_space := Vector3i(8, 4, 8)
# The offset that the blocks will spawn from
@onready var origin_offset := Vector3i(0, 2, 0)

# The surrounding blocks, used for generating new blocks (set once so it's not re-set every time a block is destroyed)
@onready var surrounding_blocks: Array[Vector3i] = [
		Vector3i(1, 0, 0), Vector3i(-1, 0, 0),
		Vector3i(0, 1, 0), Vector3i(0, -1, 0),
		Vector3i(0, 0, 1), Vector3i(0, 0, -1)
	]

@onready var block_weights: Array[float]


func _ready() -> void:
	pass


func generate_initial_blocks() -> void:
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


func set_weights(weights: Array[float]) -> void:
	# Setting the weights for the blocks
	block_weights = weights
	# print(block_weights)


var prev_map_coordinate: Vector3i

func destroy_block(world_coordinate: Vector3) -> void:
	# Making the block coordinate relative to the grid map
	var map_coordinate := local_to_map(world_coordinate)

	# Preventing trying to destroy the same block multiple times
	if map_coordinate == prev_map_coordinate:
		return

	# For debugging
	# print("map_coordinate: ", map_coordinate)

	# Tell the inventory manager to add the block to the inventory
	GameLoop.inventory_manager.add_item(GameLoop.block_helper.get_block_name_by_index(get_cell_item(map_coordinate)))

	# Destroying the block
	generate_a_block(map_coordinate, true)

	prev_map_coordinate = map_coordinate


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
	# print("generating a block")
	if is_air:
		set_cell_item(block_position, 0)
	else:
		if randi() % 4 == 0: # 25% chance to spawn ore
			var rng := RandomNumberGenerator.new()
			rng.randomize()
			
			var rarity_chosen := rng.rand_weighted(GameLoop.item_database.block_rarity_spawn_chance.values())
			var chosen_rarity: BaseBlockResource.BlockRarities = BaseBlockResource.BlockRarities.values()[rarity_chosen]
			var matching_ore_weights := []
			var amount_of_iterations_to_skip := GameLoop.item_database.default_block_amount_plus_air
			var iteration_count := 0
			for block_name in GameLoop.item_database.block_data.keys():
				if iteration_count < amount_of_iterations_to_skip:
					iteration_count += 1
					continue
				var block_rarity = GameLoop.item_database.block_data[block_name]["rarity"]
				if block_rarity == chosen_rarity:
					matching_ore_weights.append(GameLoop.item_database.block_data[block_name]["chance_to_spawn"])
				else:
					matching_ore_weights.append(0.0)

			set_cell_item(block_position, rng.rand_weighted(matching_ore_weights) + 2)
		else:
			set_cell_item(block_position, 1)
