extends Node3D

var cam_stick_speed_multiplier := 16
var twist_sens_multiplier := 1.778
var twist_input := 0.0
var pitch_input := 0.0
var cam_invert_y := true
var cam_invert_x := false
var min_pitch_angle := 10
var max_pitch_angle := 90

@onready var twist_pivot := self
@onready var pitch_pivot := $CamPitchPivot
@onready var spring_arm := $CamPitchPivot/SpringArm3D
@onready var cam := $CamPitchPivot/SpringArm3D/Camera3D

var desiredZoom := 5.0
var zoomStep := 0.01
var maxZoom := 15.0		# to clarify: min and max zoom here refer to distance from pivot
var minZoom := 3

func _ready() -> void:
	cam.make_current()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _process(delta: float) -> void:
	# Camera Movement
	# move cam at fixed rate with buttons/right joystick
	var cam_input_permanent := Input.get_vector("cam_right", "cam_left", "cam_up", "cam_down")
	cam_input_permanent = Vector2(
		(-cam_input_permanent.x if cam_invert_x else cam_input_permanent.x), 
		(-cam_input_permanent.y if cam_invert_y else cam_input_permanent.y))
	if cam_input_permanent.length():
		twist_pivot.rotate_y(cam_input_permanent.x * delta * cam_stick_speed_multiplier * twist_sens_multiplier * Global.mouse_sens)
		pitch_pivot.rotate_x(cam_input_permanent.y * delta * cam_stick_speed_multiplier * Global.mouse_sens)
		pitch_pivot.rotation.x = clamp(
			pitch_pivot.rotation.x,
			deg_to_rad(-max_pitch_angle),
			deg_to_rad(-min_pitch_angle)
		)
	# move cam with mouse
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		twist_pivot.rotate_y(twist_input * delta * twist_sens_multiplier)
		pitch_pivot.rotate_x(pitch_input * delta)
		pitch_pivot.rotation.x = clamp(
			pitch_pivot.rotation.x,
			deg_to_rad(-max_pitch_angle),
			deg_to_rad(-min_pitch_angle)
		)
		twist_input = 0.0
		pitch_input = 0.0
		
	# Camera Zoom, FOV
	var zoom_input := -(Input.is_action_just_pressed("zoom_in_scroll") as float) * 2 + (Input.is_action_just_pressed("zoom_out_scroll") as float) * 2 # Input.is_action_just_pressed works; is_action_pressed does not.
	if zoom_input == 0.0:
		zoom_input += Input.get_axis("zoom_in_noscroll", "zoom_out_noscroll")
	if zoom_input != 0.0:
		for i in abs(zoom_input * 5) as int:
			desiredZoom = clamp(desiredZoom + (zoomStep if zoom_input > 0.0 else -zoomStep), minZoom, maxZoom)
		spring_arm.spring_length = desiredZoom

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED and Global.game_state == Util.GAME_STATE.UNPAUSED:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		elif Input.mouse_mode != Input.MOUSE_MODE_VISIBLE and Global.game_state != Util.GAME_STATE.UNPAUSED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		twist_input = -event.get_screen_relative().x * Global.mouse_sens
		pitch_input = -event.get_screen_relative().y * Global.mouse_sens
