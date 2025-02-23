extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var was_on_floor := true

@onready var ink_trail_particles: GPUParticles3D = get_node("Ink Trail Particles")
@onready var ink_burst_particles_scene: PackedScene = preload("res://entities/effects/ink_burst_particles.tscn")


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	ink_trail_particles.emitting = is_on_floor()

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		print("jumping")
		#add_child(ink_burst_particles_scene.instantiate())

	# Handle landing

	if (not was_on_floor) and is_on_floor():
		print("landing")
		add_child(ink_burst_particles_scene.instantiate())


	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction = Vector3(input_dir.x, 0, input_dir.y).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	was_on_floor = is_on_floor()

	move_and_slide()
