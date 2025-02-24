@tool

extends AnimationTree
class_name BetterAnimationTree


@export var run_in_editor := false :
	set(value):
		run_in_editor = value
		_update()
@export var real_active := true :
	set(value):
		real_active = value
		_update()

# Called when the node enters the scene tree for the first time.
func _ready():
	_update()


func _update():
	active = (run_in_editor and real_active) if Engine.is_editor_hint() else real_active
