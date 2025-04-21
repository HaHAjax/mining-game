extends Control
class_name LoadingScreenScript

var next_scene: String

var packed_scene: PackedScene

var instantiated_scene

signal loading_complete(packed_scene)


func _ready() -> void:
	pass


func _process(_delta) -> void:
	if GameState.curr_game_state != GameState.GameStates.LOADING or next_scene == "":
		print("not loading or no next scene")
		return
	var progress := []
	ResourceLoader.load_threaded_get_status(next_scene, progress)
	set_visual_progress(progress[0] * 100)

	await RenderingServer.frame_post_draw
	# print("progress: ", progress[0] * 100)

	if progress[0] == 1:
		packed_scene = ResourceLoader.load_threaded_get(next_scene)
		instantiated_scene = packed_scene.instantiate()
		loading_complete.emit(instantiated_scene)


## Sets the progress bar to be the given value.
## [param value] should be between 0 and 100, like a percentage.
func set_visual_progress(value: float) -> void:
	await RenderingServer.frame_post_draw
	$VBoxContainer/ProgressBar.value = value
	$VBoxContainer/ProgressNumber.text = str(value) + "%"


func set_next_scene(next_scene_path: String) -> void:
	next_scene = next_scene_path
	ResourceLoader.load_threaded_request(next_scene)
	$VBoxContainer/ProgressBar.value = 0
	$VBoxContainer/ProgressNumber.text = "0%"

	await RenderingServer.frame_post_draw
