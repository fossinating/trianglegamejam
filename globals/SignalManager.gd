extends Node

@warning_ignore("unused_signal") signal game_state_changed(new_state: Util.GAME_STATE)
@warning_ignore("unused_signal") signal game_speed_changed(new_speed: float)

@warning_ignore("unused_signal") signal add_interaction(node: Node3D)
@warning_ignore("unused_signal") signal remove_interaction(node: Node3D)

@warning_ignore("unused_signal") signal delivery_completed(delivery: ItemDeliveryPoint)
@warning_ignore("unused_signal") signal canvas_completed(canvas: Canvas)

@warning_ignore("unused_signal") signal pause(useValue: bool, value: bool)
var just_exited_pause: bool = false
