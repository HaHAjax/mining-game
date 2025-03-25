extends Camera3D

# Export variables
@export_range(1, 100, 0.5) var mouse_sensitivity := 77.5
var desired_mouse_sensitivity := 0.0
var min_pitch := -90.0
var max_pitch := 90.0

# Getting a reference to other variables
@export var player: Node3D


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	desired_mouse_sensitivity = 1.0 - (mouse_sensitivity / 100.0)

	pass


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_x((-event.relative.y * 0.01) * desired_mouse_sensitivity)
		player.rotate_y((-event.relative.x * 0.01) * desired_mouse_sensitivity)
		rotation.x = clamp(rotation.x, deg_to_rad(min_pitch), deg_to_rad(max_pitch))
	
	pass
