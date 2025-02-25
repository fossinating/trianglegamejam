extends Node

@warning_ignore("unused_signal") signal game_state_changed(new_state: Util.GAME_STATE)
@warning_ignore("unused_signal") signal game_speed_changed(new_speed: float)

@warning_ignore("unused_signal") signal add_interaction(node: Node3D)
@warning_ignore("unused_signal") signal remove_interaction(node: Node3D)
