extends CharacterBody3D

# The export variables
@export var move_speed := 7.5
@export var jump_velocity := 10.0

# Other variables
var gravity := -9.8

# The input variables
var input_direction := Vector2.ZERO
var input_jump := false
var input_mine := false


# Helper lambda functions
var is_moving := func() -> bool: return input_direction != Vector2.ZERO
var is_mining := func() -> bool: return input_mine
var can_mine := func() -> bool: return raycast_node.is_colliding()
var is_looking_at_mineable := func() -> bool: return raycast_node.get_collider().has_method("destroy_block")
var can_jump := func() -> bool: return is_on_floor()
var attempting_jump := func() -> bool: return input_jump

# References to node(s)
@onready var raycast_node := $Camera3D/RayCast3D as RayCast3D


# May be used in the future, here just in case
func _ready():
	pass


func _physics_process(delta: float) -> void:
	# Updating input variables
	update_input()

	# Updating player movement
	update_movement(delta)

	# Updating mining operation
	update_mining()

	pass


func update_input() -> void:
	# Move direction
	input_direction = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")

	# Jump
	input_jump = Input.is_action_just_pressed("jump")

	# Mine
	input_mine = Input.is_action_pressed("mine")

	pass


func update_movement(delta: float) -> void:
	# Combining the input direction and move speed into a single vector
	var move_vector := Vector3(input_direction.x, 0, input_direction.y) * move_speed

	# Making the movement relative to the player's rotation
	move_vector = move_vector.rotated(Vector3.UP, rotation.y)

	# Applying gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0
	
	# Jumping
	if can_jump.call() and attempting_jump.call():
		velocity.y = jump_velocity
	
	# Finally, the actual movement
	velocity.x = lerpf(velocity.x, move_vector.x, delta * 10)
	velocity.z = lerpf(velocity.z, move_vector.z, delta * 10)

	# Always required when moving stuff
	move_and_slide()


func update_mining() -> void:
	if is_mining.call() and can_mine.call():
		if is_looking_at_mineable.call():

			# Getting the block position
			var block_position := raycast_node.get_collision_point() - raycast_node.get_collision_normal()

			# Fixing the position to be accurate on certain edge cases
			if raycast_node.get_collision_normal().x == -1:
				block_position.x -= 1
			if raycast_node.get_collision_normal().y == -1:
				block_position.y -= 1
			if raycast_node.get_collision_normal().z == -1:
				block_position.z -= 1
			
			# For debugging
			# print("Collision normal: ", block_position - raycast_node.get_collision_point())
			# print("Collision point: ", raycast_node.get_collision_point())
			# print("Combined: ", block_position)

			# Destroying the block
			raycast_node.get_collider().destroy_block(block_position)

			# Generating new blocks around the destroyed block
			var modified_block_position: Vector3i = raycast_node.get_collider().local_to_map(block_position) # Getting the destroyed block's position on the GridMap
			raycast_node.get_collider().generate_new_blocks(modified_block_position) # Calling the function to actually generate the blocks
