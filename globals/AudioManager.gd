extends Node3D

var sound_effect_dict = {}

@export var sound_effect_settings : Array[SoundEffectSettings]

func _ready():
	for sound_effect_setting : SoundEffectSettings in sound_effect_settings:
		sound_effect_dict[sound_effect_setting.type] = sound_effect_setting

func create_3d_audio_at_location(location, type: SoundEffectSettings.SOUND_EFFECT_TYPE):
	if sound_effect_dict.has(type):
		var sound_effect_setting: SoundEffectSettings = sound_effect_dict[type]
		if sound_effect_setting.has_open_limit():
			sound_effect_setting.change_audio_count(1)
			var new_3D_audio = AudioStreamPlayer3D.new()
			add_child(new_3D_audio)
			
			new_3D_audio.positon = location
			new_3D_audio.stream = sound_effect_setting.sound_effect
			new_3D_audio.volume_db = sound_effect_setting.volume_db
			new_3D_audio.pitch_scale = sound_effect_setting.pitch_scale
			new_3D_audio.pitch_scale += Global.rng.randf_range(-sound_effect_setting.pitch_randomness, sound_effect_setting.pitch_randomness)
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
