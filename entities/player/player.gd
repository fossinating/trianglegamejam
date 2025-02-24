extends CharacterBody3D


const ACCELERATION := 8.0
const FRICTION := 8.0
const MOVING_FRICTION := 4.0

@export var Jump_Peak_Time := 0.8
@export var Jump_Fall_Time := 0.6
@export var Jump_Height := 3.0
@export var Jump_Distance := 12.0

var max_speed := 5.0
var jump_velocity := 8.0
var jump_gravity := 1.0
var fall_gravity := 1.2

@onready var visuals := $blob
@export var ROT_SPEED : float = TAU * 2
var _theta : float

@onready var airborne_visuals := $blob/Armature/Skeleton3D/mesh
@onready var painting_visuals := $blob/AnimatedSprite3D

@onready var ink_trail_airborne := $"blob/Armature/Skeleton3D/BoneAttachment3D2/Ink Airborne Trail Particles"
@onready var ink_trail_painting := $"blob/Ink Trail Particles"

@onready var airborne_eyes := $blob/Armature/Skeleton3D/EyesBoneAttachment3D

@onready var ink_waterfall_detection_raycast: RayCast3D = $"Ink Waterfall Detection"
@onready var ink_burst_particles_scene: PackedScene = preload("res://entities/effects/ink_burst_particles.tscn")

@onready var animation_tree: AnimationTree = $AnimationTree

@onready var skeleton: Skeleton3D = $"blob/Armature/Skeleton3D"

var swim_val := 0.0
enum ModelStates { JUMP, SWIM }
var currentAnim = ModelStates.JUMP
var blend_speed = 15

var landing_velocity: Vector3
@export var landing_force := 50.0

@onready var item_grabber := $"Item Grabber"


var jumping := false

@onready var twist_pivot := $CamTwistPivot

func _ready() -> void:
	if Global.game_state == Util.GAME_STATE.MENU:
		Global.game_state = Util.GAME_STATE.UNPAUSED
	max_speed = Jump_Distance/(Jump_Peak_Time+Jump_Fall_Time)
	jump_gravity = (2 * Jump_Height)/pow(Jump_Peak_Time,2)
	fall_gravity = (2*Jump_Height)/pow(Jump_Fall_Time,2)
	jump_velocity = jump_gravity * Jump_Peak_Time
	print("max speed: ", max_speed)
	print("jump gravity: ", jump_gravity)
	print("fall_gravity: ", fall_gravity)
	print("jump_velocity: ", jump_velocity)

	#Engine.time_scale = 0.1


func _physics_process(delta: float) -> void:
	
	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction: Vector3 = (twist_pivot.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	var horiz_vel = velocity
	horiz_vel.y = 0

	if direction:
		horiz_vel += direction * ACCELERATION * delta

		if horiz_vel.length_squared() > max_speed*max_speed:
			horiz_vel = horiz_vel.normalized() * max_speed
		
		_theta = wrapf(atan2(direction.x, direction.z) - visuals.rotation.y, -PI, PI)
		visuals.rotation.y += clamp(ROT_SPEED * delta, 0, abs(_theta)) * sign(_theta)
	
	horiz_vel -= min((MOVING_FRICTION if direction else FRICTION)*delta, horiz_vel.length()) * horiz_vel.normalized()

	velocity.x = horiz_vel.x
	velocity.z = horiz_vel.z

	# Handle ink waterfall climbing
	ink_waterfall_detection_raycast.target_position = direction


	# Technically this will be a single physics frame behind, but shouldn't be too much of a problem hopefully
	var climbing_waterfall = ink_waterfall_detection_raycast.is_colliding() and direction.length_squared() > 0.1

	if climbing_waterfall:
		velocity.y += jump_gravity * delta
		currentAnim = ModelStates.SWIM
	else:
		currentAnim = ModelStates.JUMP

	var is_on_surface = is_on_floor() or climbing_waterfall

	# Add gravity only if not on a surface + climbing waterfall
	if not is_on_surface:
		velocity += -Vector3(0, 1, 0) * (jump_gravity if (velocity.y > 0) else fall_gravity) * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor() and not climbing_waterfall:
		velocity.y = jump_velocity
		#print("jumping")
		jumping = true
		item_grabber.drop_current_item()
		#add_child(ink_burst_particles_scene.instantiate())
		
	handle_animations(delta)

	# Setup handling of landing

	var was_on_surface = is_on_floor() or climbing_waterfall

	if not was_on_surface:
		landing_velocity = velocity

	move_and_slide()

	if not (is_on_floor() or climbing_waterfall):
		if velocity.y > 0:
			skeleton.rotation_degrees.x = clamp(remap(velocity.y, 0, 5, 0, -35), -35, 0)
		else:
			skeleton.rotation_degrees.x = clamp(remap(velocity.y, 0, -10, 0, 125), 0, 125)

	# Handle landing
	# We handle landing here since so animations can trigger immediately, rather than on next physics frame(~1/30th of a second later)

	if jumping and (not was_on_surface) and is_on_floor():
		#print("landing")
		add_child(ink_burst_particles_scene.instantiate())


	# Push skeleton into the wall if swimming up a waterfall
	if climbing_waterfall:
		skeleton.position.x = ink_waterfall_detection_raycast.get_collision_normal().x * 5
		skeleton.position.z = ink_waterfall_detection_raycast.get_collision_normal().z * 5
		skeleton.rotation_degrees.x = -75
	else:
		skeleton.position.x = 0
		skeleton.position.z = 0
	
	print(global_position)
	print(velocity)

	if is_on_floor():
		skeleton.position.y = max(-17, skeleton.position.y + landing_velocity.y*delta)
		landing_velocity.y -= landing_force*fall_gravity*delta
	elif velocity.y > 0:
		skeleton.position.y = min(0, skeleton.position.y + 5*velocity.y*delta)

	painting_visuals.visible = is_on_floor() and skeleton.position.y <= -5
	ink_trail_painting.emitting = painting_visuals.visible
	airborne_visuals.visible = (not is_on_floor()) or skeleton.position.y > -17
	ink_trail_airborne.emitting = not painting_visuals.visible
	airborne_eyes.visible = airborne_visuals.visible


func handle_animations(delta):
	match currentAnim:
		ModelStates.JUMP:
			swim_val = lerpf(swim_val, 0, blend_speed * delta)
		ModelStates.SWIM:
			swim_val = lerpf(swim_val, 1, blend_speed * delta)

func update_tree():
	animation_tree["parameters/BlendTree/Swim/blend_amount"] = swim_val
