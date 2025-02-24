extends Area3D


var current_item
var hovered_item

const MAX_HOLD_DISTANCE = 0.5


func _physics_process(delta: float) -> void:
	if current_item:
		var dist = current_item.global_position.distance_to(global_position)
		if dist > MAX_HOLD_DISTANCE:
			current_item.global_position = lerp(current_item.global_position, 
			global_position + (current_item.global_position - global_position) / dist * MAX_HOLD_DISTANCE, 0.9)
			


func get_interaction_text() -> String:
	if current_item and hovered_item: 
		return "Swap"
	if current_item:
		return "Drop"
	if hovered_item:
		return "Pickup"
	return ""


func interact() -> void:
	if current_item and hovered_item:
		var tmp = hovered_item
		drop_item(current_item)
		pickup_item(tmp)
	elif current_item:
		drop_item(current_item)
	elif hovered_item:
		pickup_item(hovered_item)

func _on_area_entered(area: Area3D) -> void:
	Signals.add_interaction.emit(self)
	hovered_item = area

func _on_area_exited(area: Area3D) -> void:
	Signals.remove_interaction.emit(self)
	if hovered_item == area:
		hovered_item = null

func pickup_item(item: Area3D) -> void:
	item.collision_layer = 0
	item.reparent(self)
	item.top_level = true
	current_item = item
	Signals.add_interaction.emit(self)

func drop_item(item: Area3D) -> void:
	item.collision_layer = 1 << 3
	item.reparent(get_parent().get_parent())
	item.top_level = false
	hovered_item = item
	current_item = null
	Signals.remove_interaction.emit(self)
	
func drop_current_item() -> void:
	if current_item:
		drop_item(current_item)
