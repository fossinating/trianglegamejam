extends Resource
class_name SoundEffectSettings
enum SOUND_EFFECT_TYPE {
	ON_JUMP,
	ON_LAND,
	BUBBLE_WOBBLE,
	BUBBLE_POP,
	BUBBLE_STREAM,
	LAUNCHER_LAUNCH,
	LAUNCHER_REGENERATE,
	PISTON_EXTEND,
	PISTON_RETRACT,
	PRESSURE_PLATE_DOWN,
	PRESSURE_PLATE_UP,
	RATING_LIKE,
	RATING_DISLIKE
}

@export_range(0, 10) var limit : int = 5
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
