extends Node

enum GAME_STATE { MENU, UNPAUSED, PAUSED }
enum MATERIAL_TYPE { PLAYER, INK, PAINTING, CANVAS, FLOOR }
enum GAME_SCENES { MENU, GAME }

var GAME_PATH := "res://levels/PLACEHOLDER!!!!!!!!!!!!!!"
var MENU_PATH := "res://levels/PLACEHOLDER!!!!!!!!!!!!!!"

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		pause()

func pause():
	if Global.game_state == Util.GAME_STATE.UNPAUSED:
		Global.game_state = Util.GAME_STATE.PAUSED
		get_tree().paused = true
	elif Global.game_state == Util.GAME_STATE.PAUSED:
		Global.game_state = Util.GAME_STATE.UNPAUSED
		get_tree().paused = false

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED and Global.game_state == GAME_STATE.UNPAUSED:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		elif Input.mouse_mode != Input.MOUSE_MODE_VISIBLE and Global.game_state != GAME_STATE.UNPAUSED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
