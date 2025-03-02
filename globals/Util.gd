extends Node

enum GAME_STATE { MENU, UNPAUSED, PAUSED }
enum MATERIAL_TYPE { PLAYER, INK, PAINTING, CANVAS, FLOOR }
enum GAME_SCENES { MENU, GAME }

var GAME_PATH := "demolevel" # PLACEHOLDER
var MENU_PATH := "MainMenu"

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	Signals.pause.connect(pause)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED and Global.game_state == GAME_STATE.UNPAUSED:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		elif Input.mouse_mode != Input.MOUSE_MODE_VISIBLE and Global.game_state != GAME_STATE.UNPAUSED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func pause(useValue: bool = false, value: bool = true):
	if not useValue:
		value = true
	if value and (Global.game_state == Util.GAME_STATE.UNPAUSED or Global.game_states == Util.GAME_STATE.PAUSED):
		Global.player.pause_menu.show()
		Signals.just_exited_pause = true
		get_tree().paused = true
		Global.game_state = Util.GAME_STATE.PAUSED
	elif not value:
		Global.player.pause_menu.hide()
		Signals.just_exited_pause = true
		get_tree().paused = false
		Global.player.pause_menu.reset_pause_menu()
		Global.game_state = Util.GAME_STATE.UNPAUSED
	if Signals.just_exited_pause:
			await get_tree().create_timer(.01).timeout
			Signals.just_exited_pause = false

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
