extends Node


signal game_state_changed(new_state: Util.GAME_STATE)
signal game_speed_changed(new_speed: float)

signal add_interaction(node: Node3D)
signal remove_interaction(node: Node3D)
