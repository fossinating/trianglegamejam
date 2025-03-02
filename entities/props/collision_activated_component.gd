extends RigidBody3D

@export var script_to_activate: Node3D
var activated := false
@export var min_collision_activation_velocity := 0.02

func activate(speed: float):
	if activated or speed < min_collision_activation_velocity:
		return
	elif speed >= min_collision_activation_velocity:
		activated = true
		if script_to_activate and script_to_activate.has_method("activate"):
			script_to_activate.activate()
		else:
			push_warning("Tried to Activate Collision-Activated Trigger but Script or Method Missing!")
