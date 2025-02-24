extends Node3D


var interactions = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.add_interaction.connect(add_interaction)
	Signals.remove_interaction.connect(remove_interaction)
	
func add_interaction(interaction: Node3D) -> void:
	interactions.append(interaction)

func remove_interaction(interaction: Node3D) -> void:
	interactions.erase(interaction)
	
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("grab"):
		if interactions.size() > 0:
			interactions.back().interact()
