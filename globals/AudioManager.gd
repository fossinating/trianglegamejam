extends Node3D

var sound_effect_dict = {}
var music_dict = {}

@export var sound_effect_settings : Array[SoundEffectSettings]
@export var music_settings : Array[SoundEffectSettings]


func _ready():
	for sound_effect_setting : SoundEffectSettings in sound_effect_settings:
		sound_effect_dict[sound_effect_setting.type] = sound_effect_setting
	for music_track : SoundEffectSettings in music_settings:
		music_dict[music_track.name] = music_track
		if music_track.type != SoundEffectSettings.SOUND_EFFECT_TYPE.MUSIC:
			push_warning("A member of the Music Track array is not of the type Music!")
		if music_track.name == "" or music_track.name == null:
			push_warning("A member of the Music Track array has a blank name!")

func play_music(name: String):
	if music_dict.has(name):
		var music_setting: SoundEffectSettings = music_dict[name]
		# TODO: set up variables to track volume and fade out, switch, and fade back in using _process
		Global.player.music_player.stream = music_setting.sound_effect
		Global.player.music_player.volume_db = music_setting.volume_db
		Global.player.music_player.pitch_scale = music_setting.pitch_scale
		Global.player.music_player.play()
	else :
		push_error("Audio Manager failed to find music of the name ", name)

func create_3d_audio_at_location(location, type: SoundEffectSettings.SOUND_EFFECT_TYPE):
	if sound_effect_dict.has(type):
		if type == SoundEffectSettings.SOUND_EFFECT_TYPE.UNASSIGNED:
			push_warning("Audio Manager is playing a file with the Unassigned type!")
		var sound_effect_setting: SoundEffectSettings = sound_effect_dict[type]
		if sound_effect_setting.has_open_limit():
			sound_effect_setting.change_audio_count(1)
			var new_3D_audio = AudioStreamPlayer3D.new()
			add_child(new_3D_audio)
			
			new_3D_audio.positon = location
			new_3D_audio.stream = sound_effect_setting.sound_effect
			new_3D_audio.volume_db = sound_effect_setting.volume_db
			new_3D_audio.pitch_scale = sound_effect_setting.pitch_scale + Global.rng.randf_range(-sound_effect_setting.pitch_randomness, sound_effect_setting.pitch_randomness)
			new_3D_audio.finished.connect(sound_effect_setting.on_audio_finished)
			new_3D_audio.finished.connect(new_3D_audio.queue_free)
			
			new_3D_audio.play()
	else :
		push_error("Audio Manager failed to find setting for type ", type)

func create_audio(type: SoundEffectSettings.SOUND_EFFECT_TYPE):
	if sound_effect_dict.has(type):
		var sound_effect_setting: SoundEffectSettings = sound_effect_dict[type]
		if sound_effect_setting.has_open_limit():
			sound_effect_setting.change_audio_count(1)
			var new_3D_audio = AudioStreamPlayer3D.new()
			add_child(new_3D_audio)
			
			new_3D_audio.stream = sound_effect_setting.sound_effect
			new_3D_audio.volume_db = sound_effect_setting.volume_db
			new_3D_audio.pitch_scale = sound_effect_setting.pitch_scale
			new_3D_audio.pitch_scale += Global.rng.randf_range(-sound_effect_setting.pitch_randomness, sound_effect_setting.pitch_randomness)
			new_3D_audio.finished.connect(sound_effect_setting.on_audio_finished)
			new_3D_audio.finished.connect(new_3D_audio.queue_free)
			
			new_3D_audio.play()
		
	else :
		push_error("Audio Manager failed to find setting for type ", type)
