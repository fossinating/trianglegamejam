extends Area3D
class_name ItemGrabber


var current_item
var hovered_item

const MAX_HOLD_DISTANCE = 0.5		


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
	if area != current_item:
		Signals.add_interaction.emit(self)
		hovered_item = area

func _on_area_exited(area: Area3D) -> void:
	if area != current_item:
		Signals.remove_interaction.emit(self)
		if hovered_item == area:
			hovered_item = null

func pickup_item(item: GrabbableItem) -> void:
	item.reparent(self)
	item.on_pickup(self)
	item.top_level = true
	current_item = item
	Signals.add_interaction.emit(self)

func drop_item(item: GrabbableItem) -> void:
	item.reparent(get_parent().get_parent())
	current_item.on_drop(self)
	item.top_level = false
	current_item = null
	Signals.remove_interaction.emit(self)
	
func drop_current_item() -> void:
	if current_item:
		drop_item(current_item)
