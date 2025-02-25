@tool

extends Area3D
class_name GrabbableItem


@export var delivery_point: ItemDeliveryPoint
@export var item_image: Texture2D

@onready var delivery_direction_particles: GPUParticles3D = $"CollisionShape3D/Delivery Direction Particles"
@onready var collision_shape: CollisionShape3D = $"CollisionShape3D"

@export var MAX_CARRY_DISTANCE := .75
@export var shrink_factor := 1.0

var carrier: ItemGrabber

@onready var sprite_carrier: Node3D = $"Sprite Carrier"
var scale_mult := 1.0


func _ready():
	if not delivery_point:
		push_error("GrabbableItem was not assigned delivery point.")

		if not Engine.is_editor_hint():
			get_tree().quit()

	$"Sprite Carrier/Sprite3D".texture = item_image
	

func _process(delta: float) -> void:
	scale_mult = clamp(scale_mult + delta * (1-shrink_factor) * (-1 if carrier else 1), shrink_factor, 1.0)
	sprite_carrier.scale = scale_mult * Vector3.ONE

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
