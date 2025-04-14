extends Camera3D

# Export variables
@export_range(1, 100, 0.5) var mouse_sensitivity := 77.5
var desired_mouse_sensitivity := 0.0
var min_pitch := -90.0
var max_pitch := 90.0

# Getting a reference to other variables
@export var player: Node3D


func _ready():
	# Capturing the mouse on load
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	# Calculating the desired mouse sensitivity from an arbitrary value between 1 and 100
	desired_mouse_sensitivity = 1.0 - (mouse_sensitivity / 100.0)

	# GameLoop.connect("game_state_changed", on_pause_unpause, (GameLoop.curr_game_state == GameLoop.GameStates.PAUSED))
	GameLoop.game_paused.connect(on_pause)
	GameLoop.game_unpaused.connect(on_unpause)


func _input(event: InputEvent) -> void:
	# If the mouse is moving AND the mouse isn't visible,
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		# Rotate the camera's pitch based on the mouse movement and the sensitivity
		rotate_x((-event.relative.y * 0.01) * desired_mouse_sensitivity)
		# Clamping the rotation to the min and max pitch
		rotation.x = clamp(rotation.x, deg_to_rad(min_pitch), deg_to_rad(max_pitch))

		# Rotate the player as well
		player.rotate_y((-event.relative.x * 0.01) * desired_mouse_sensitivity)
	
	# Just "pausing" or "unpausing" the game based on the mouse mode
	# if Input.is_action_just_pressed("pause") and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
	# 	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	# elif Input.is_action_just_pressed("pause") and Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
	# 	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func on_pause() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func on_unpause() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
