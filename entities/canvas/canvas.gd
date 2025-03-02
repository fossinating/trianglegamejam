@tool
extends Node3D
class_name Canvas

@export var incomplete_texture: Texture2D
@export var complete_texture: Texture2D

@export var size := 1.0

@export var reload: bool:
	set(value):
		reload = false
		setup()

var deliveries_left: Array[ItemDeliveryPoint] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup()

func get_bounding_box() -> Vector3:
	return size * Vector3(0.15, 1.98 * (1 if is_square else 16.0/9), 1.98)

func is_square() -> bool:
	return incomplete_texture.get_width() == incomplete_texture.get_height()

func setup() -> void:
	if not incomplete_texture:
		push_error("No incomplete texture assigned")
	
	$Pivot/canvasV1.visible = not is_square()
	$Pivot/squareCanvasV1.visible = is_square()
	
	$CollisionShape3D.shape.size = size * Vector3(.15, 1.98 * (1 if is_square() else 16.0/9), 1.98)
	
	$Pivot.scale = size * Vector3.ONE
	
	$Pivot/Sprite3D.texture = incomplete_texture
	$Pivot/Sprite3D.pixel_size = 2.0 / incomplete_texture.get_width()
	var collision_shape := $CollisionShape3D
	
	collision_shape.shape.size = get_bounding_box()
	collision_shape.position.x = -0.075 * size
	
	var particle_collision_box: GPUParticlesCollisionBox3D = $GPUParticlesCollisionBox3D
	
	particle_collision_box.size = get_bounding_box()
	particle_collision_box.position.x = -0.075 * size


func register_delivery(delivery: ItemDeliveryPoint) -> void:
	deliveries_left.append(delivery)

func complete_delivery(delivery: ItemDeliveryPoint) -> void:
	deliveries_left.erase(delivery)
	
	if deliveries_left.size() == 0:
		Signals.canvas_completed.emit(self)
		$Pivot/Sprite3D.texture = complete_texture
		$GPUParticles3D.position = delivery.position
		$GPUParticles3D.emitting = true
	else:
		Signals.delivery_completed.emit(delivery)
