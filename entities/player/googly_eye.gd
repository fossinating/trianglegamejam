extends Node3D


@onready var black_bit: MeshInstance3D = get_node("Black bit")

var last_position: Vector3


@export_range(0, 1.0) var inherit_velocity = 0.5
@export_range(0, 1.0) var damping = 0.1

@export_range(0, 90) var rand_max_rotation = 10


var black_bit_velocity := Vector3.ZERO

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float):
	if last_position:
		var difference = global_position - last_position
		difference.y = 0

		black_bit_velocity -= difference * inherit_velocity

		black_bit.position += black_bit_velocity * delta


		var dist = black_bit.position.length()
		if dist > 0.045:
			black_bit.position *= 0.045 / dist
			black_bit_velocity = -black_bit_velocity.rotated(Vector3.UP, deg_to_rad(randf_range(-rand_max_rotation, rand_max_rotation)))

		black_bit_velocity -= black_bit_velocity * damping * delta

		print(black_bit_velocity)



		


	last_position = global_position
