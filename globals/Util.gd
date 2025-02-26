extends Node

enum GAME_STATE { MENU, UNPAUSED, PAUSED }
enum MATERIAL_TYPE { PLAYER, INK, PAINTING, CANVAS, FLOOR }
enum GAME_SCENES { MENU, GAME }

var GAME_PATH := "workshop" # PLACEHOLDER
var MENU_PATH := "MainMenu"

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED and Global.game_state == GAME_STATE.UNPAUSED:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		elif Input.mouse_mode != Input.MOUSE_MODE_VISIBLE and Global.game_state != GAME_STATE.UNPAUSED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func change_scene_at_pos(scene_name : String, load_pos := Vector3(0.0, 0.5, 0.0)):
	get_tree().change_scene_to_file(str("res://levels/", scene_name, ".tscn"))
	#DiscordManager.change_scene(scene_name)
	
	var playerWrapper := get_tree().root.find_child("Player")
	if playerWrapper:
		Global.player = playerWrapper
		Global.player.position = load_pos

func change_scene_at_checkpoint(scene_name : String, load_checkpoint := Global.current_checkpoint):
	get_tree().change_scene_to_file(str("res://levels/", scene_name, ".tscn"))
	#DiscordManager.change_scene(scene_name)
	
	# TODO spawn at specified checkpoint
	change_scene_at_pos(scene_name) # TEMPORARY
