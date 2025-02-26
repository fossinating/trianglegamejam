@tool
extends Node3D
class_name Canvas3D

@onready var texture_viewport: SubViewport = $"TextureSubViewport"

@export var size: float = 1.0

@export var painting: Painting

@export var reload: bool:
	set(value):
		reload = false
		setup()

var canvas_model: Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup()

func setup() -> void:
	if not painting:
		push_error(false, "Canvas not assigned a painting")
		return
	
	canvas_model = $"Canvas Model Pivot/Canvas Square" if painting.is_square() else $"Canvas Model Pivot/Canvas"
	
	$"Canvas Model Pivot/Canvas Square".visible = painting.is_square()
	$"Canvas Model Pivot/Canvas".visible = not painting.is_square()
	
	texture_viewport.size = painting.PIXELS_PER_METER * 2 * size * Vector2.ONE
	
	var canvas_mesh: MeshInstance3D = $"Canvas Model Pivot/Canvas Square/16by9canvas" if painting.is_square() else $"Canvas Model Pivot/Canvas/16by9 template_001"
	
	var material = StandardMaterial3D.new()
	
	material.albedo_texture = texture_viewport.get_texture()
	
	canvas_mesh.set_surface_override_material(2, material)
	
	$CollisionShape3D.shape.size = size * Vector3(0.15, 1.98 * (1 if painting.is_square() else 16.0/9), 1.98)
	$CollisionShape3D.position.x = -0.075 * size
	
	$"Canvas Model Pivot".scale = size * Vector3.ONE
	
	print("canvas loaded")
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
