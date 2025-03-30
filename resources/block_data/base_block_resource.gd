extends Resource
class_name BaseBlockResource

enum BlockTypes {
	AIR,
	DEFAULT,
	ORE
}
enum BlockRarities {
	NONE = -1,
	COMMON = 0,
	UNCOMMON = 1,
	RARE = 2,
	EPIC = 3,
	LEGENDARY = 4,
	MYTHIC = 5
}
# Currently temporary, does nothing for now
enum BlockSpawnDepths {
	ANYWHERE = -1,
	LAYER_ONE,
	LAYER_TWO,
	LAYER_THREE,
	LAYER_FOUR,
	LAYER_FIVE,
	LAYER_SIX,
	LAYER_SEVEN,
	LAYER_EIGHT,
}

@export_category("Block Data")
@export var block_name: String
@export var block_type: BlockTypes
@export var rarity: BlockRarities
@export var spawn_depth: BlockSpawnDepths
@export_range(0, 1, 0.01) var chance_to_spawn: float = 0.5

@export_category("MeshLibrary Data")
@export var block_mesh: Mesh
