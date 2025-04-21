@tool
extends MeshLibrary
class_name BlockHelper

var instance: BlockHelper

func _init():
	if instance == null:
		instance = self


# TODO:
# - Put comments here and there

## Automagically sets everything up :>
## @deprecated: This doesn't work anymore for some reason, so don't use the button
@export_tool_button("Setup Everything", "Callable") var setup_everything_button := setup_everything

## The resources for each block.
## Can be set manually, or automatically by pressing the button above.
@export var block_resources: Array[BaseBlockResource]

## The path to the folder containing the default block resources
var default_block_resource_folder_path: String = "res://resources/block_resources/block_data/defaults/"
## The path to the folder containing the ore resources
var ore_block_resource_folder_path: String = "res://resources/block_resources/block_data/ores/"

## The default collision shape for the blocks, if none is set
var default_collision_shape := preload("uid://dysnpfgth8dg2")

## The block rarities.
## @experimental: currently hardcoded, should be dynamic in the future 
var block_rarities: Array[String] = [
	"common/",
	"uncommon/",
	"rare/",
	"epic/",
	"legendary/",
	"mythic/"
]


## The function that sets up the mesh library to place the blocks, and sets the block resources for the block information at the same index as the mesh library.
func setup_everything():
	# Setup the mesh library
	await setup_mesh_library()

	GameLoop.loading_screen_instance.set_visual_progress(50)

	# Set the block resources
	await set_block_resources()

	GameLoop.loading_screen_instance.set_visual_progress(99)

	# Make it update in the editor
	notify_property_list_changed()


## The function that sets the block resources, used for the block information.
func set_block_resources():
	# Clear the block resources array
	block_resources.clear()

	# Loading the defaults first
	for item_index in 2:
		var item_name := get_item_name(item_index).to_snake_case()
		var block_resource := load(default_block_resource_folder_path + item_name + ".tres") as BaseBlockResource
		if block_resource == null:
			push_error("Block resource not found: " + item_name)
			continue
		block_resources.append(block_resource)
	
	# Loading the ores after
	for rarity in block_rarities:
		for item_index in get_item_list().size() - 2:
			var item_name := get_item_name(item_index + 2).to_snake_case()
			if ResourceLoader.exists(ore_block_resource_folder_path + rarity + item_name + ".tres"):
				var block_resource := load(ore_block_resource_folder_path + rarity + item_name + ".tres") as BaseBlockResource
				if block_resource == null:
					push_error("Block resource not found: " + rarity + item_name)
					continue
				else:
					block_resources.append(block_resource)


## Sets up the mesh library for the GridMap to place the blocks.
func setup_mesh_library():
	# Clear the mesh library
	clear()

	var default_block_directory := DirAccess.open(default_block_resource_folder_path)
	default_block_directory.list_dir_begin()
	var default_block_file_names := default_block_directory.get_files()
	default_block_directory.list_dir_end()

	var amount_of_default_blocks := 0
	
	for file_name in default_block_file_names:
		var file_index = default_block_file_names.find(file_name)
		amount_of_default_blocks += 1
		create_item(file_index)
		var block_resource := load(default_block_resource_folder_path + file_name) as BaseBlockResource
		set_item_mesh(file_index, block_resource.block_mesh)
		set_item_name(file_index, block_resource.block_name.to_pascal_case())
		if file_name == "air.tres":
			set_item_shapes(file_index, [])
		else:
			set_item_shapes(file_index, [default_collision_shape])
			set_item_preview(file_index, block_resource.item_preview)
	
	var ore_block_file_names := []
	var ore_index := amount_of_default_blocks

	for rarity in block_rarities:
		var ore_block_directory := DirAccess.open(ore_block_resource_folder_path + rarity)
		if ore_block_directory == null:
			push_error("Directory not found: " + ore_block_resource_folder_path + rarity)
			break
		ore_block_directory.list_dir_begin()
		ore_block_file_names.append(Array(ore_block_directory.get_files()))
		ore_block_directory.list_dir_end()

		if ore_block_file_names.size() == 0:
			push_error("No ore block files found in: " + ore_block_resource_folder_path + rarity)
		else:
			for i in range(ore_block_file_names.size()):
				# print(ore_block_file_names[i])
				ore_block_file_names[i].sort_custom(sort_by_rarity)

	for i in range(ore_block_file_names.size()):
		for file_name in ore_block_file_names[i]:
			create_item(ore_index)
			var block_resource: BaseBlockResource
			for rarity in block_rarities:
				if ResourceLoader.exists(ore_block_resource_folder_path + rarity + file_name):
					block_resource = load(ore_block_resource_folder_path + rarity + file_name) as BaseBlockResource
					break
				else:
					# push_error("Block resource not found: " + rarity + file_name)
					continue
			if block_resource != null:
				set_item_mesh(ore_index, block_resource.block_mesh)
				set_item_name(ore_index, block_resource.block_name.to_pascal_case())
				set_item_shapes(ore_index, [default_collision_shape])
				set_item_preview(ore_index, block_resource.item_preview)
				ore_index += 1
			else:
				push_error("Block resource not found: " +  file_name)
				
	# print(get_item_list())


## Gets the block rarity by name.
## The block rarity is used to determine how often that each block in a rarity should spawn in the world.
func get_block_rarity_by_name(inputted_block_name: String) -> BaseBlockResource.BlockRarities:
	for block_resource in block_resources:
		if block_resource.block_name.to_lower() == inputted_block_name:
			# Return the rarity of the block resource
			return block_resource.rarity
	
	# If the block resource is not found, return none
	return BaseBlockResource.BlockRarities.NONE

## Gets the block type by name. [br]
## The block type is used to determine if the block is an ore, air, or a default block.
func get_block_type_by_name(inputted_block_name: String) -> BaseBlockResource.BlockTypes:
	for block_resource in block_resources:
		if block_resource.block_name.to_lower() == inputted_block_name:
			# Return the type of the block resource
			return block_resource.block_type
	
	# If the block resource is not found, return none
	return BaseBlockResource.BlockTypes.AIR

## Gets the block spawn depth by name. [br]
## The spawn depth is for what depth the block should spawn in the world.
func get_block_spawn_depth_by_name(inputted_block_name: String) -> BaseBlockResource.BlockSpawnDepths:
	for block_resource in block_resources:
		if block_resource.block_name.to_lower() == inputted_block_name:
			# Return the spawn depth of the block resource
			return block_resource.spawn_depth
	
	# If the block resource is not found, return none
	return BaseBlockResource.BlockSpawnDepths.ANYWHERE

## Gets the block chance to spawn by name. [br]
## The chance to spawn is used to determine how likely the block is to spawn, if the rarity has been chosen.
func get_block_chance_to_spawn_by_name(inputted_block_name: String) -> float:
	for block_resource in block_resources:
		if block_resource.block_name.to_lower() == inputted_block_name:
			# Return the chance to spawn of the block resource
			return block_resource.chance_to_spawn
	
	# If the block resource is not found, return none
	return 0.0

## Gets the block index by name. [br]
## The block index is determined by the order of the block resources in the array and the mesh library. [br]
## The block index should be unique from every other block.
func get_block_index_by_name(inputted_block_name: String) -> int:
	for i in range(block_resources.size()):
		if block_resources[i].block_name.to_lower() == inputted_block_name:
			# Return the index of the block resource
			return i
	
	# If the block resource is not found, return -1
	return -1


## Gets the block rarity by index. [br]
## The block rarity is used to determine how often that each block in a rarity should spawn in the world.
func get_block_rarity_by_index(index: int) -> BaseBlockResource.BlockRarities:
	if index >= 0 and index < block_resources.size():
		return block_resources[index].rarity
	
	# If the index is out of bounds, return none
	return BaseBlockResource.BlockRarities.NONE

## Gets the block type by index. [br]
## The block type is used to determine if the block is an ore, air, or a default block.
func get_block_type_by_index(index: int) -> BaseBlockResource.BlockTypes:
	if index >= 0 and index < block_resources.size():
		return block_resources[index].block_type
	
	# If the index is out of bounds, return none
	return BaseBlockResource.BlockTypes.AIR

## Gets the block spawn depth by index. [br]
## The spawn depth is for what depth the block should spawn in the world.
func get_block_spawn_depth_by_index(index: int) -> BaseBlockResource.BlockSpawnDepths:
	if index >= 0 and index < block_resources.size():
		return block_resources[index].spawn_depth
	
	# If the index is out of bounds, return none
	return BaseBlockResource.BlockSpawnDepths.ANYWHERE

## Gets the block's chance to spawn by index. [br]
## The chance to spawn is used to determine how likely the block is to spawn, if the rarity has been chosen.
func get_block_chance_to_spawn_by_index(index: int) -> float:
	if index >= 0 and index < block_resources.size():
		return block_resources[index].chance_to_spawn
	
	# If the index is out of bounds, return none
	return 0.0

## Gets the block name by index. [br]
## The block name is used to identify the block in the world. [br]
## The block name should be unique from every other block.
func get_block_name_by_index(index: int) -> String:
	if index >= 0 and index < block_resources.size():
		return block_resources[index].block_name
	
	# If the index is out of bounds, return none
	return ""


func _ready():
	pass


## Sorts the block resources by rarity. [br]
## Should only be used when sorting an array.
func sort_by_rarity(a: String, b: String) -> bool:
	var a_file_path: String
	var b_file_path: String
	for rarity in block_rarities:
		a_file_path = ore_block_resource_folder_path + rarity + a
		b_file_path = ore_block_resource_folder_path + rarity + b

		var a_block_resource: BaseBlockResource
		var b_block_resource: BaseBlockResource

		if ResourceLoader.exists(a_file_path) and ResourceLoader.exists(b_file_path):
			a_block_resource = load(a_file_path) as BaseBlockResource
			b_block_resource = load(b_file_path) as BaseBlockResource
		else:
			return false

		# if a_block_resource == null or b_block_resource == null:
		# 	return false

		# Sort by rarity
		if a_block_resource.rarity < b_block_resource.rarity:
			return true
		elif a_block_resource.rarity > b_block_resource.rarity:
			return false
		else:
			# If the rarities are the same, sort by name
			if a_block_resource.chance_to_spawn > b_block_resource.chance_to_spawn:
				return true
			elif a_block_resource.chance_to_spawn < b_block_resource.chance_to_spawn:
				return false
	return false


## Gets the amount of files in a directory.
## @deprecated: currently unused, but may be needed in the future.
func get_file_count(path: String) -> int:
	var dir := DirAccess.open(path)
	dir.list_dir_begin()

	var file_count := 0
	while true:
		var file := dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			file_count += 1

	dir.list_dir_end()
	return file_count
