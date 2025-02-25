extends Area3D
class_name GrabbableItem


@export var delivery_point: ItemDeliveryPoint


@onready var delivery_direction_particles: GPUParticles3D = $"Delivery Direction Particles"
@onready var collision_shape: CollisionShape3D = $"CollisionShape3D"

@export var MAX_CARRY_DISTANCE = .75

var carrier: ItemGrabber

func _ready():
	if not delivery_point:
		push_error("GrabbableItem was not assigned delivery point.")
		get_tree().quit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	if carrier:
		var dist = global_position.distance_to(carrier.global_position)
		if dist > MAX_CARRY_DISTANCE:
			global_position = lerp(global_position, 
			carrier.global_position + (global_position - carrier.global_position) / dist * MAX_CARRY_DISTANCE, 0.9)

		delivery_direction_particles.look_at(Vector3(delivery_point.global_position.x, 0, delivery_point.global_position.z))


func on_pickup(grabber: ItemGrabber) -> void:
	carrier = grabber
	delivery_direction_particles.visible = true

func on_drop(grabber: ItemGrabber) -> void:
	if carrier == grabber:
		carrier = null
		delivery_direction_particles.visible = false
	else:
		push_error("An ItemGrabber tried dropping an item it was not holding")
