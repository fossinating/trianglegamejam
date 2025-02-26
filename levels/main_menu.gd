extends Control

var volBusMaster = AudioServer.get_bus_index("Master")
var volBusMUS = AudioServer.get_bus_index("MUS")
var volBusSFX = AudioServer.get_bus_index("SFX")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	UpdateSliderVisuals()


func _on_button_play_pressed() -> void:
	Util.change_scene_at_checkpoint(Util.GAME_PATH)

func _on_button_options_pressed() -> void:
	$TitleLabel.visible = false
	$MainVBox.visible = false
	$OptionsMarginContainer.visible = true
	UpdateSliderVisuals()

func _on_button_back_pressed() -> void:
	$OptionsMarginContainer.visible = false
	$MainVBox.visible = true
	$TitleLabel.visible = true

func _on_button_exit_pressed() -> void:
	#save?
	get_tree().quit()


func _on_volume_master_value_changed(value: float) -> void:
	ChangeBusVolume(volBusMaster, value)

func _on_volume_music_value_changed(value: float) -> void:
	ChangeBusVolume(volBusMUS, value)

func _on_volume_sfx_value_changed(value: float) -> void:
	ChangeBusVolume(volBusSFX, value)

func ChangeBusVolume(index: int, value: float) -> void:
	var vol = linear_to_db(value)
	if value == 0:
		AudioServer.set_bus_mute(index, true)
	else:
		AudioServer.set_bus_mute(index, false)
	AudioServer.set_bus_volume_db(index, vol)

func UpdateSliderVisuals():
	$OptionsMarginContainer/VBoxContainer/VolumeMaster.value = db_to_linear(AudioServer.get_bus_volume_db(volBusMaster))
	$OptionsMarginContainer/VBoxContainer/VolumeMusic.value = db_to_linear(AudioServer.get_bus_volume_db(volBusMUS))
	$OptionsMarginContainer/VBoxContainer/VolumeSFX.value = db_to_linear(AudioServer.get_bus_volume_db(volBusSFX))
	$OptionsMarginContainer/VBoxContainer/MouseSensitivity.value = Global.mouse_sens

func _on_cheats_check_box_toggled(toggled_on: bool) -> void:
	Global.cheats_enabled = toggled_on


func _on_fullscreen_check_box_toggled(toggled_on: bool) -> void:
	if toggled_on:
		get_window().set_mode(Window.MODE_FULLSCREEN)
	else:
		get_window().set_mode(Window.MODE_WINDOWED)


func _on_mouse_sensitivity_value_changed(value: float) -> void:
	Global.mouse_sens = value
