extends RefCounted
class_name ItemDatabase

var _block_uids := {
	"air" = "uid://c6f0xrxysihy5",
	"stone" = "uid://dhulexiov7gye",
	"testing_common" = "uid://dswffhq1jhlmp",
	"coal" = "uid://cgm6a10s8i6bw",
	"testing_uncommon" = "uid://dn2unky0ircn4",
	"iron" = "uid://laaqnvkxj53i",
	"testing_rare" = "uid://doby8ypt4r52o",
	"testing_epic" = "uid://cnnc2r5rc2rjb",
}

var block_data := {}

var _block_rarity_spawn_chance := {
	"none": 0.0,
	"common": 0.5,
	"uncommon": 0.3,
	"rare": 0.15,
	"epic": 0.05,
	"legendary": 0.01,
	"mythic": 0.005
}

var block_rarity_spawn_chance: Dictionary:
	get:
		return _block_rarity_spawn_chance

var _default_block_amount_plus_air: int = 2

var default_block_amount_plus_air: int:
	get:
		return _default_block_amount_plus_air


func _ready():
	pass


func get_block_data() -> Dictionary:
	return block_data


func set_block_data() -> void:
	for block_name in _block_uids.keys():
		var block_uid = _block_uids[block_name]
		var block_resource = load(block_uid)
		if block_resource == null:
			push_error("Block resource not found: " + block_name)
			continue
		block_data[block_name] = {
			"uid": block_uid,
			"name": block_resource.block_name,
			"type": block_resource.block_type,
			"rarity": block_resource.rarity,
			"spawn_depth": block_resource.spawn_depth,
			"chance_to_spawn": block_resource.chance_to_spawn,
			"mesh": block_resource.block_mesh,
			"item_preview": block_resource.item_preview
		}


func get_rarity_color(rarity: BaseBlockResource.BlockRarities) -> Color:
	match rarity:
		BaseBlockResource.BlockRarities.NONE:
			return Color(1, 1, 1) # White
		BaseBlockResource.BlockRarities.COMMON:
			return Color(0.5, 0.5, 0.5) # Gray
		BaseBlockResource.BlockRarities.UNCOMMON:
			return Color(0, 1, 0) # Green
		BaseBlockResource.BlockRarities.RARE:
			return Color(0, 0, 1) # Blue
		BaseBlockResource.BlockRarities.EPIC:
			return Color(1, 0, 1) # Purple
		BaseBlockResource.BlockRarities.LEGENDARY:
			return Color(1, 0.5, 0) # Orange
		BaseBlockResource.BlockRarities.MYTHIC:
			return Color(1, 1, 0) # Yellow
	return Color.WHITE
