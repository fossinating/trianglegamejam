extends Area3D
class_name ItemDeliveryPoint


var delivered_item: GrabbableItem

# Called every frame. 'delta' is the elapsed time since the previous frame.
func deliver(item) -> void:
	delivered_item = item
	delivered_item.reparent(self)
	
func _process(delta: float) -> void:
	if delivered_item:
		if delivered_item.position.length() > 0.05:
			delivered_item.position += -1 * min(2*delta, delivered_item.position.length()) * delivered_item.position.normalized()
		else:
			delivered_item.position = Vector3.ZERO


func _on_area_entered(area: Area3D):
	# Only do something if the delivery hasn't already been made
	# and if the area3d is a GrabbableItem
	if (not delivered_item) and is_instance_of(area, GrabbableItem):
		# Also check to make sure it is the right item
		if (area as GrabbableItem).delivery_point == self:
			delivered_item = area
			if (area as GrabbableItem).carrier:
				(area as GrabbableItem).carrier.drop_item((area as GrabbableItem))
			delivered_item.reparent(self)
			delivered_item.top_level = false
			delivered_item.collision_shape.set_deferred("disabled", true)
