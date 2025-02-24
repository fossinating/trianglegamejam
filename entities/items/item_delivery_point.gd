extends Area3D


var delivered_item

# Called every frame. 'delta' is the elapsed time since the previous frame.
func deliver(item) -> void:
	delivered_item = item
	delivered_item.reparent(self)
	
func _process(delta: float) -> void:
	if delivered_item:
		delivered_item.position = -1 * min(2*delta, delivered_item.position.length()) * delivered_item.position.normalized()
