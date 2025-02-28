@tool
extends VBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


var rangeX := Vector2.ZERO
var rangeY := Vector2.ZERO
var rangeZ := Vector2.ZERO

func _on_rotate_button_pressed() -> void:
	var selection = EditorInterface.get_selection()
	var useStackingBox := $HBoxStacking/CheckBox
	var currentStackOffset := 0.0
	
	var startingPosition := Vector3.ZERO
	selection.get_selected_nodes()[0].position = startingPosition
	for node in selection.get_selected_nodes():
		if node is Node3D:
			var randomRotation := Vector3(deg_to_rad(randf_range(rangeX.x, rangeX.y)), deg_to_rad(randf_range(rangeY.x, rangeY.y)), deg_to_rad(randf_range(rangeZ.x, rangeZ.y)))
			node.rotation = randomRotation
			if useStackingBox.toggled:
				node.position.y = startingPosition.y + currentStackOffset
				currentStackOffset += stack_interval

func only_float(current_value: float, new_text: String):
	var value = current_value
	if new_text.is_valid_float():
		value = float(new_text)
		return [value, true]
	else:
		return [value, false]

var stack_interval := 0.0
func _on_line_edit_stack_interval_text_changed(new_text: String) -> void:
	if new_text == "":
		stack_interval = 0.0
		$HBoxStacking/LineEditStackInterval.text = "0"
	if only_float(float($HBoxStacking/LineEditStackInterval.text), new_text)[1]:
		stack_interval = float($HBoxStacking/LineEditStackInterval.text)
	else:
		$HBoxStacking/LineEditStackInterval.text = str(stack_interval)


func _on_line_edit_min_x_text_changed(new_text: String) -> void:
	if new_text == "":
		rangeX.x = 0.0
		$HBoxContainerRotationMin/LineEditMinX.text = "0"
	if only_float(float($HBoxContainerRotationMin/LineEditMinX.text), new_text)[1]:
		rangeX.x = float($HBoxContainerRotationMin/LineEditMinX.text)
	else:
		$HBoxContainerRotationMin/LineEditMinX.text = str(rangeX.x)


func _on_line_edit_min_y_text_changed(new_text: String) -> void:
	if new_text == "":
		rangeY.x = 0.0
		$HBoxContainerRotationMin/LineEditMinY.text = "0"
	if only_float(float($HBoxContainerRotationMin/LineEditMinY.text), new_text)[1]:
		rangeY.x = float($HBoxContainerRotationMin/LineEditMinY.text)
	else:
		$HBoxContainerRotationMin/LineEditMinY.text = str(rangeY.x)


func _on_line_edit_min_z_text_changed(new_text: String) -> void:
	if new_text == "":
		rangeZ.x = 0.0
		$HBoxContainerRotationMin/LineEditMinZ.text = "0"
	if only_float(float($HBoxContainerRotationMin/LineEditMinZ.text), new_text)[1]:
		rangeZ.x = float($HBoxContainerRotationMin/LineEditMinZ.text)
	else:
		$HBoxContainerRotationMin/LineEditMinZ.text = str(rangeZ.x)


func _on_line_edit_max_x_text_changed(new_text: String) -> void:
	if new_text == "":
		rangeX.y = 0.0
		$HBoxContainerRotationMax/LineEditMaxX.text = "0"
	if only_float(float($HBoxContainerRotationMax/LineEditMaxX.text), new_text)[1]:
		rangeX.y = float($HBoxContainerRotationMax/LineEditMaxX.text)
	else:
		$HBoxContainerRotationMax/LineEditMaxX.text = str(rangeX.y)


func _on_line_edit_max_y_text_changed(new_text: String) -> void:
	if new_text == "":
		rangeY.y = 0.0
		$HBoxContainerRotationMax/LineEditMaxY.text = "0"
	if only_float(float($HBoxContainerRotationMax/LineEditMaxY.text), new_text)[1]:
		rangeY.y = float($HBoxContainerRotationMax/LineEditMaxY.text)
	else:
		$HBoxContainerRotationMax/LineEditMaxY.text = str(rangeY.y)


func _on_line_edit_max_z_text_changed(new_text: String) -> void:
	if new_text == "":
		rangeZ.y = 0.0
		$HBoxContainerRotationMax/LineEditMaxZ.text = "0"
	if only_float(float($HBoxContainerRotationMax/LineEditMaxZ.text), new_text)[1]:
		rangeZ.y = float($HBoxContainerRotationMax/LineEditMaxZ.text)
	else:
		$HBoxContainerRotationMax/LineEditMaxZ.text = str(rangeZ.y)
