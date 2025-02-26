@tool
extends Node2D
class_name Painting

const PIXELS_PER_METER := 50

@export var texture: Texture2D

@export var reload: bool:
	set(value):
		reload = false
		setup()

@export var canvas: Canvas3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup()


func setup() -> void:
	# Set up everything internal to this scene
	# Will not set up anything for the canvas, including the SubViewport
	# This will result in weird in-engine camera values, but it should hopefully be fine
	if not texture:
		push_error(false, "Painting not provided a texture")
		return
		
	if not canvas:
		push_warning("Painting not provided a canvas")
	
	var painting_sprite: Sprite2D = $"Painting Sprite"
	
	painting_sprite.texture = texture
	
	# These calculations are based on the width since the width is always 2 meters
	# Take the canvas size multiplier times 2 to get the width in meters
	# Multiply by PIXELS_PER_METER to get the width in pixels
	var pixel_width = (canvas.size if canvas else 1.0) * 2 * PIXELS_PER_METER
	
	# Divide by the texture's width to get the scaling value we need
	# Mulitply by Vector2.ONE to convert it into a Vector2
	painting_sprite.scale = pixel_width / texture.get_width() * Vector2.ONE
	
	#$Camera2D.offset = -Vector2(pixel_width / 2.0, pixel_width / 2.0 * (1 if is_square() else 16.0/9))
	
	# Set up the walls to prevent the player from leaving the canvas
	$"Walls/Upper Wall/CollisionShape2D".shape.distance = -pixel_width / 2.0 * (1 if is_square() else 16.0/9)
	$"Walls/Lower Wall/CollisionShape2D".shape.distance = -pixel_width / 2.0 * (1 if is_square() else 16.0/9)
	$"Walls/Right Wall/CollisionShape2D".shape.distance = -pixel_width / 2.0
	$"Walls/Left Wall/CollisionShape2D".shape.distance = -pixel_width / 2.0
	

func is_square() -> bool:
	if not texture:
		push_error("Painting not provided a texture")
		return false
		
	return texture.get_width() == texture.get_height()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
