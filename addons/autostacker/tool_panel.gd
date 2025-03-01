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
	var box := $HBoxStacking/LineEditStackInterval
	if new_text == "":
		stack_interval = 0.0
	elif new_text == "-":
		stack_interval = 0.0
	elif new_text.length() >= 2 and new_text.substr(0, new_text.length() - 1).is_valid_float() and new_text[new_text.length() - 1] == "-":
		stack_interval = float(new_text.substr(0, new_text.length() - 1)) * -1.0
		if float(new_text.substr(0, new_text.length() - 1)) == 0:
			stack_interval = 0
			box.text = str("-", new_text.substr(0, new_text.length() - 1))
		else:
			box.text = str(stack_interval)
	elif only_float(float(box.text), new_text)[1]:
		stack_interval = float(box.text)
	else:
		box.text = str(stack_interval)
	box.caret_column = new_text.length()


func _on_line_edit_min_x_text_changed(new_text: String) -> void:
	var box := $HBoxContainerRotationMin/LineEditMinX
	if new_text == "":
		rangeX.x = 0.0
	elif new_text == "-":
		rangeX.x = 0.0
	elif new_text.length() >= 2 and new_text.substr(0, new_text.length() - 1).is_valid_float() and new_text[new_text.length() - 1] == "-":
		rangeX.x = float(new_text.substr(0, new_text.length() - 1)) * -1.0
		if float(new_text.substr(0, new_text.length() - 1)) == 0:
			rangeX.x = 0
			box.text = str("-", new_text.substr(0, new_text.length() - 1))
		else:
			box.text = str(rangeX.x)
	elif only_float(float(box.text), new_text)[1]:
		rangeX.x = float(box.text)
	else:
		box.text = str(rangeX.x)
	box.caret_column = new_text.length()


func _on_line_edit_min_y_text_changed(new_text: String) -> void:
	var box := $HBoxContainerRotationMin/LineEditMinY
	if new_text == "":
		rangeY.x = 0.0
	elif new_text == "-":
		rangeY.x = 0.0
	elif new_text.length() >= 2 and new_text.substr(0, new_text.length() - 1).is_valid_float() and new_text[new_text.length() - 1] == "-":
		rangeY.x = float(new_text.substr(0, new_text.length() - 1)) * -1.0
		if float(new_text.substr(0, new_text.length() - 1)) == 0:
			rangeY.x = 0
			box.text = str("-", new_text.substr(0, new_text.length() - 1))
		else:
			box.text = str(rangeY.x)
	elif only_float(float(box.text), new_text)[1]:
		rangeY.x = float(box.text)
	else:
		box.text = str(rangeY.x)
	box.caret_column = new_text.length()


func _on_line_edit_min_z_text_changed(new_text: String) -> void:
	var box := $HBoxContainerRotationMin/LineEditMinZ
	if new_text == "":
		rangeZ.x = 0.0
	elif new_text == "-":
		rangeZ.x = 0.0
	elif new_text.length() >= 2 and new_text.substr(0, new_text.length() - 1).is_valid_float() and new_text[new_text.length() - 1] == "-":
		rangeZ.x = float(new_text.substr(0, new_text.length() - 1)) * -1.0
		if float(new_text.substr(0, new_text.length() - 1)) == 0:
			rangeZ.x = 0
			box.text = str("-", new_text.substr(0, new_text.length() - 1))
		else:
			box.text = str(rangeZ.x)
	elif only_float(float(box.text), new_text)[1]:
		rangeZ.x = float(box.text)
	else:
		box.text = str(rangeZ.x)
	box.caret_column = new_text.length()


func _on_line_edit_max_x_text_changed(new_text: String) -> void:
	var box := $HBoxContainerRotationMax/LineEditMaxX
	if new_text == "":
		rangeX.y = 0.0
	elif new_text == "-":
		rangeX.y = 0.0
	elif new_text.length() >= 2 and new_text.substr(0, new_text.length() - 1).is_valid_float() and new_text[new_text.length() - 1] == "-":
		rangeX.y = float(new_text.substr(0, new_text.length() - 1)) * -1.0
		if float(new_text.substr(0, new_text.length() - 1)) == 0:
			rangeX.y = 0
			box.text = str("-", new_text.substr(0, new_text.length() - 1))
		else:
			box.text = str(rangeX.y)
	elif only_float(float(box.text), new_text)[1]:
		rangeX.y = float(box.text)
	else:
		box.text = str(rangeX.y)
	box.caret_column = new_text.length()


func _on_line_edit_max_y_text_changed(new_text: String) -> void:
	var box := $HBoxContainerRotationMax/LineEditMaxY
	if new_text == "":
		rangeY.y = 0.0
	elif new_text == "-":
		rangeY.y = 0.0
	elif new_text.length() >= 2 and new_text.substr(0, new_text.length() - 1).is_valid_float() and new_text[new_text.length() - 1] == "-":
		rangeY.y = float(new_text.substr(0, new_text.length() - 1)) * -1.0
		if float(new_text.substr(0, new_text.length() - 1)) == 0:
			rangeY.y = 0
			box.text = str("-", new_text.substr(0, new_text.length() - 1))
		else:
			box.text = str(rangeY.y)
	elif only_float(float(box.text), new_text)[1]:
		rangeY.y = float(box.text)
	else:
		box.text = str(rangeY.y)
	box.caret_column = new_text.length()


func _on_line_edit_max_z_text_changed(new_text: String) -> void:
	var box := $HBoxContainerRotationMax/LineEditMaxZ
	if new_text == "":
		rangeZ.y = 0.0
	elif new_text == "-":
		rangeZ.y = 0.0
	elif new_text.length() >= 2 and new_text.substr(0, new_text.length() - 1).is_valid_float() and new_text[new_text.length() - 1] == "-":
		rangeZ.y = float(new_text.substr(0, new_text.length() - 1)) * -1.0
		if float(new_text.substr(0, new_text.length() - 1)) == 0:
			rangeZ.y = 0
			box.text = str("-", new_text.substr(0, new_text.length() - 1))
		else:
			box.text = str(rangeZ.y)
	elif only_float(float(box.text), new_text)[1]:
		rangeZ.y = float(box.text)
	else:
		box.text = str(rangeZ.y)
	box.caret_column = new_text.length()
