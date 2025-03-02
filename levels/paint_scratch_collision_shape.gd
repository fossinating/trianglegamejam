extends CollisionShape3D

func activate() -> void:
	disabled = true
	get_parent().visible = false
