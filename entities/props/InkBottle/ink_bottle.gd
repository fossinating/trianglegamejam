extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func activate():
	print("Spill Activated!")
	$AnimationPlayer.play("spill")
