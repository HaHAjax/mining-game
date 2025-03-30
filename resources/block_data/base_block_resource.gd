extends Resource
class_name BaseBlockResource

enum BlockTypes {
	AIR,
	DEFAULT,
	ORE
}
enum BlockRarities {
	NONE = -1,
	COMMON,
	UNCOMMON,
	RARE,
	EPIC,
	LEGENDARY,
	MYTHIC
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

@export var block_name: String
@export var block_type: BlockTypes
@export var rarity: BlockRarities
@export var spawn_depth: BlockSpawnDepths
@export_range(0, 1, 0.01) var chance_to_spawn: float = 0.5	
