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

#@onready var animation_tree: AnimationTree = $AnimationTree

@onready var skeleton: Skeleton3D = $"blob/Armature/Skeleton3D"

@onready var music_player: AudioStreamPlayer3D = $MusicPlayer

var swim_val := 0.0
#enum ModelStates { JUMP, SWIM }
#var currentAnim = ModelStates.JUMP
var blend_speed = 15

var landing_velocity: Vector3
@export var landing_force := 50.0

@onready var item_grabber := $"Item Grabber"


var jumping := false

@onready var twist_pivot := $CamTwistPivot
@onready var cam := $CamTwistPivot/CamPitchPivot/SpringArm3D/Camera3D

var noclip_speed_mult := 1.0
var noclip := false
var cam_aligned_wish_dir := Vector3.ZERO

@onready var pause_menu := $PauseMenu

func _ready() -> void:
	if Global.game_state == Util.GAME_STATE.MENU:
		Global.game_state = Util.GAME_STATE.UNPAUSED
	if Global.player == null:
		Global.player = self
	max_speed = Jump_Distance/(Jump_Peak_Time+Jump_Fall_Time)
	jump_gravity = (2 * Jump_Height)/pow(Jump_Peak_Time,2)
	fall_gravity = (2*Jump_Height)/pow(Jump_Fall_Time,2)
	jump_velocity = jump_gravity * Jump_Peak_Time
	print("max speed: ", max_speed)
	print("jump gravity: ", jump_gravity)
	print("fall_gravity: ", fall_gravity)
	print("jump_velocity: ", jump_velocity)
	AudioManager.play_music("Flowing Ink")

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause") and Global.game_state == Util.GAME_STATE.UNPAUSED and !Signals.just_exited_pause:
		Signals.pause.emit(true, true)
	if Input.is_action_just_pressed("pause") and Global.game_state == Util.GAME_STATE.PAUSED and !Signals.just_exited_pause:
		Signals.pause.emit(true, false)

func _physics_process(delta: float) -> void:
	
	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	cam_aligned_wish_dir = cam.global_transform.basis * Vector3(input_dir.x, 0., input_dir.y)
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

	if !_handle_noclip(delta):
		velocity.x = horiz_vel.x
		velocity.z = horiz_vel.z

	# Handle ink waterfall climbing
	# Multiplying by 0.51 to set the length to slightly larger than the size of the character
	ink_waterfall_detection_raycast.target_position = direction * 0.51
	
	# Technically this will be a single physics frame behind, but shouldn't be too much of a problem hopefully
	var climbing_waterfall = ink_waterfall_detection_raycast.is_colliding() and direction.length_squared() > 0.1

	if climbing_waterfall:
		velocity.y += jump_gravity * delta
		#currentAnim = ModelStates.SWIM
	#else:
		#currentAnim = ModelStates.JUMP

	var is_on_surface = is_on_floor() or climbing_waterfall

	# Add gravity only if not on a surface + climbing waterfall
	if not is_on_surface:
		velocity += -Vector3(0, 1, 0) * (jump_gravity if (velocity.y > 0) else fall_gravity) * delta

	if !_handle_noclip(delta):
		# Handle jump.
		if Input.is_action_just_pressed("jump") and is_on_floor() and not climbing_waterfall:
			velocity.y = jump_velocity
			#print("jumping")
			jumping = true
			item_grabber.drop_current_item()
			#add_child(ink_burst_particles_scene.instantiate())
			
		#	handle_animations(delta)
		elif climbing_waterfall:
			item_grabber.drop_current_item()
		elif not is_on_floor():
			item_grabber.drop_current_item()

	# Setup handling of landing

	var was_on_surface = is_on_floor() or climbing_waterfall

	if not was_on_surface:
		landing_velocity = velocity
	if !_handle_noclip(delta):
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
		# Define a "goal point" inside the wall and move towards it
		skeleton.position.y = max(-10, skeleton.position.y)
		var goal_point = visuals.global_position - ink_waterfall_detection_raycast.get_collision_normal() * .5
		var goal_vector = goal_point - skeleton.global_position
		skeleton.global_position += min(3*delta, goal_vector.length()) * goal_vector.normalized()
		skeleton.rotation = Vector3(deg_to_rad(-75), 0, 0)
	else:
		# Move back towards a "reset" position
		skeleton.position -= min(3*delta, skeleton.position.length()) * skeleton.position.normalized()
		
	# this handles pulling the model in and out of the floor
	if not (is_on_floor() or climbing_waterfall):
		if velocity.y > 0:
			skeleton.position.y = min(0, skeleton.position.y + 5*velocity.y*delta)
	elif is_on_floor():
		skeleton.position.y = max(-17, skeleton.position.y + landing_velocity.y*delta)
		landing_velocity.y -= landing_force*fall_gravity*delta

	if noclip:
		painting_visuals.visible = false
		ink_trail_painting.emitting = false
		airborne_visuals.visible = true
		ink_trail_airborne.emitting = false
		airborne_eyes.visible = airborne_visuals.visible
	else:
		painting_visuals.visible = is_on_floor() and skeleton.position.y <= -5
		ink_trail_painting.emitting = painting_visuals.visible
		airborne_visuals.visible = (not is_on_floor()) or skeleton.position.y > -17
		ink_trail_airborne.emitting = not painting_visuals.visible
		airborne_eyes.visible = airborne_visuals.visible

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed() and noclip:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			noclip_speed_mult = min(100.0, noclip_speed_mult * 1.1)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			noclip_speed_mult = max(0.1, noclip_speed_mult * 0.9)

func _handle_noclip(delta) -> bool:
	if Input.is_action_just_pressed("no_clip") and (Global.cheats_enabled):
		noclip = !noclip
		noclip_speed_mult = 1.0
	elif !Global.cheats_enabled:
		noclip = false
	
	$CollisionShape3D.disabled = noclip
	
	if not noclip:
		return false
	
	var speed = max_speed * noclip_speed_mult
	if Input.is_action_pressed("sprint"):
		speed *= 3.0
	
	velocity = cam_aligned_wish_dir * speed
	
	if Input.is_action_pressed("jump"):
		velocity.y += speed
	if Input.is_action_pressed("crouch"):
		velocity.y -= speed
	
	global_position += self.velocity * delta
	
	return true

#func handle_animations(delta):
	#match currentAnim:
		#ModelStates.JUMP:
			#swim_val = lerpf(swim_val, 0, blend_speed * delta)
		#ModelStates.SWIM:
			#swim_val = lerpf(swim_val, 1, blend_speed * delta)

#func update_tree():
	#animation_tree["parameters/BlendTree/Swim/blend_amount"] = swim_val
