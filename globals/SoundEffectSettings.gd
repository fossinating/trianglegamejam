extends Resource
class_name SoundEffectSettings
enum SOUND_EFFECT_TYPE {
	UNASSIGNED,
	MUSIC,
	ON_JUMP,
	ON_LAND,
	SWIMMING,
	GRAB,
	DROP,
	INK_SPILL,
	BRUSH_STROKE,
	UI_SELECT,
	UI_BACK,
	UI_PLAY,
	AMBIENCE
}

@export_range(0, 10) var limit : int = 5
@export var name: String
@export var type: SOUND_EFFECT_TYPE
@export var sound_effect: AudioStream
@export_range(-40, 20) var volume_db = 0
@export_range(0.0, 4.0, 0.01) var pitch_scale = 1.0
@export_range(0.0, 1.0, 0.01) var pitch_randomness = 0.0

var audio_count = 0

func change_audio_count(amount: int):
	audio_count = max(0, audio_count + amount)
	
func has_open_limit() -> bool:
	return audio_count < limit
	
func on_audio_finished():
	change_audio_count(-1)
