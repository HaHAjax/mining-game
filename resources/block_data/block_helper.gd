@tool
extends MeshLibrary
class_name BlockHelper

@export var block_resources: Array[BaseBlockResource]


# The following 5 functions help to get the block resource variables by name
func get_block_rarity_by_name(inputted_block_name: String) -> BaseBlockResource.BlockRarities:
	for block_resource in block_resources:
		if block_resource.block_name.to_lower() == inputted_block_name:
			# Return the rarity of the block resource
			return block_resource.rarity
	
	# If the block resource is not found, return none
	return BaseBlockResource.BlockRarities.NONE

func get_block_type_by_name(inputted_block_name: String) -> BaseBlockResource.BlockTypes:
	for block_resource in block_resources:
		if block_resource.block_name.to_lower() == inputted_block_name:
			# Return the type of the block resource
			return block_resource.block_type
	
	# If the block resource is not found, return none
	return BaseBlockResource.BlockTypes.AIR

func get_block_spawn_depth_by_name(inputted_block_name: String) -> BaseBlockResource.BlockSpawnDepths:
	for block_resource in block_resources:
		if block_resource.block_name.to_lower() == inputted_block_name:
			# Return the spawn depth of the block resource
			return block_resource.spawn_depth
	
	# If the block resource is not found, return none
	return BaseBlockResource.BlockSpawnDepths.ANYWHERE

func get_block_chance_to_spawn_by_name(inputted_block_name: String) -> float:
	for block_resource in block_resources:
		if block_resource.block_name.to_lower() == inputted_block_name:
			# Return the chance to spawn of the block resource
			return block_resource.chance_to_spawn
	
	# If the block resource is not found, return none
	return 0.0

func get_block_index_by_name(inputted_block_name: String) -> int:
	for i in range(block_resources.size()):
		if block_resources[i].block_name.to_lower() == inputted_block_name:
			# Return the index of the block resource
			return i
	
	# If the block resource is not found, return -1
	return -1


# The following 5 functions help to get the block resource variables by index
func get_block_rarity_by_index(index: int) -> BaseBlockResource.BlockRarities:
	if index >= 0 and index < block_resources.size():
		return block_resources[index].rarity
	
	# If the index is out of bounds, return none
	return BaseBlockResource.BlockRarities.NONE

func get_block_type_by_index(index: int) -> BaseBlockResource.BlockTypes:
	if index >= 0 and index < block_resources.size():
		return block_resources[index].block_type
	
	# If the index is out of bounds, return none
	return BaseBlockResource.BlockTypes.AIR

func get_block_spawn_depth_by_index(index: int) -> BaseBlockResource.BlockSpawnDepths:
	if index >= 0 and index < block_resources.size():
		return block_resources[index].spawn_depth
	
	# If the index is out of bounds, return none
	return BaseBlockResource.BlockSpawnDepths.ANYWHERE

func get_block_chance_to_spawn_by_index(index: int) -> float:
	if index >= 0 and index < block_resources.size():
		return block_resources[index].chance_to_spawn
	
	# If the index is out of bounds, return none
	return 0.0

func get_block_name_by_index(index: int) -> String:
	if index >= 0 and index < block_resources.size():
		return block_resources[index].block_name
	
	# If the index is out of bounds, return none
	return ""


func _ready():
	pass
