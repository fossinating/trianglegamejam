extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@onready var ink_trail_particles: GPUParticles3D = get_node("Ink Trail Particles")
@onready var ink_waterfall_detection_raycast: RayCast3D = get_node("Ink Waterfall Detection")
@onready var ink_burst_particles_scene: PackedScene = preload("res://entities/effects/ink_burst_particles.tscn")

var jumping = false


func _physics_process(delta: float) -> void:

	# Get the input direction and handle the movement/deceleration.
	# TODO: Change this movement to acceleration-based to better fit a fluid creature
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction = Vector3(input_dir.x, 0, input_dir.y).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	# Handle ink waterfall climbing
	ink_waterfall_detection_raycast.target_position = direction


	# Technically this will be a single physics frame behind, but shouldn't be too much of a problem hopefully
	var climbing_waterfall = ink_waterfall_detection_raycast.is_colliding() and direction.length_squared() > 0.1

	if climbing_waterfall:
		velocity -= get_gravity() * delta

	var is_on_surface = is_on_floor() or climbing_waterfall

	# Add gravity only if not on a surface + climbing waterfall
	if not is_on_surface:
		velocity += get_gravity() * delta


	ink_trail_particles.emitting = is_on_floor() or climbing_waterfall

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor() and not climbing_waterfall:
		velocity.y = JUMP_VELOCITY
		print("jumping")
		jumping = true
		#add_child(ink_burst_particles_scene.instantiate())


	# Setup handling of landing

	var was_on_surface = is_on_floor() or climbing_waterfall

	move_and_slide()

	# Handle landing
	# We handle landing here since so animations can trigger immediately, rather than on next physics frame(~1/30th of a second later)

	if jumping and (not was_on_surface) and is_on_floor():
		print("landing")
		add_child(ink_burst_particles_scene.instantiate())

