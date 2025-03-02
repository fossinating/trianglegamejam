@tool
extends VBoxContainer

var undo_redo : EditorUndoRedoManager

var rangeX := Vector2.ZERO
var rangeY := Vector2.ZERO
var rangeZ := Vector2.ZERO

func _on_rotate_button_pressed() -> void:
	var selection = EditorInterface.get_selection()
	var useStackingBox := $HBoxStacking/CheckBox
	var currentStackOffset := 0.0
	
	undo_redo.create_action("Autostacker: Rotate & Stack Nodes")
	
	var startingPosition := Vector3.ZERO
	startingPosition = selection.get_selected_nodes()[0].position
	for node in selection.get_selected_nodes():
		if node is Node3D:
			var randomRotation := Vector3(deg_to_rad(randf_range(rangeX.x, rangeX.y)), deg_to_rad(randf_range(rangeY.x, rangeY.y)), deg_to_rad(randf_range(rangeZ.x, rangeZ.y)))
			var rot = node.rotation
			var pos = node.position
			rot = randomRotation
			if useStackingBox.toggled:
				pos.y = startingPosition.y + currentStackOffset
				currentStackOffset += stack_interval
			
			undo_redo.add_do_property(node, "rotation", rot)
			undo_redo.add_do_property(node, "position", pos)
			undo_redo.add_undo_property(node, "rotation", node.rotation)
			undo_redo.add_undo_property(node, "position", node.position)
			
	undo_redo.commit_action()

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
	elif new_text == ".":
		stack_interval = 0.0
		box.text = "0."
		new_text = "0."
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
	elif new_text == ".":
		rangeX.x = 0.0
		box.text = "0."
		new_text = "0."
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
	elif new_text == ".":
		rangeY.x = 0.0
		box.text = "0."
		new_text = "0."
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
	elif new_text == ".":
		rangeZ.x = 0.0
		box.text = "0."
		new_text = "0."
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
	elif new_text == ".":
		rangeX.y = 0.0
		box.text = "0."
		new_text = "0."
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
	elif new_text == ".":
		rangeY.y = 0.0
		box.text = "0."
		new_text = "0."
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
	elif new_text == ".":
		rangeZ.y = 0.0
		box.text = "0."
		new_text = "0."
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

#
#var negativeCorner := Vector2(0.0, 0.0)
#var positiveCorner := Vector2(0.0, 0.0)
#var tiling_interval := Vector2(0.0, 0.0)
#
#func _on_tile_button_pressed() -> void:
	#var selection = EditorInterface.get_selection()
	#
	#undo_redo.create_action("Autostacker: Tile Nodes")
	#
	#var startingPosition := Vector3.ZERO
	#
	#if !load(tilePath) :
		#push_warning("Error loading scene ", tilePath)
	#else:
		#var tileNode = load(tilePath)
		#for i in range(negativeCorner.x, positiveCorner.x):
			#for j in range(negativeCorner.y, positiveCorner.y):
				#if tileNode is Node3D:
					#var new_node: Node3D = tileNode.new()
					#get_tree().edited_scene_root.add_child(new_node)
					#var pos = Vector3(new_node.position.x + i * tiling_interval.x, new_node.position.y, new_node.position.z + j * tiling_interval.y)
					#
					#undo_redo.add_do_method(new_node, "new")
					#undo_redo.add_do_property(new_node, "position", pos)
					#undo_redo.add_undo_property(new_node, "position", new_node.position)
					#undo_redo.add_undo_method(new_node, "new")
			#
	#undo_redo.commit_action()
#
#func _on_line_edit_size_x_text_changed(new_text: String) -> void:
	#var box := $HBoxTilingSize/LineEditSizeX
	#if new_text == "":
		#tiling_interval.x = 0.0
	#elif new_text == "-":
		#tiling_interval.x = 0.0
	#elif new_text == ".":
		#tiling_interval.x = 0.0
		#box.text = "0."
		#new_text = "0."
	#elif new_text.length() >= 2 and new_text.substr(0, new_text.length() - 1).is_valid_float() and new_text[new_text.length() - 1] == "-":
		#tiling_interval.x = float(new_text.substr(0, new_text.length() - 1)) * -1.0
		#if float(new_text.substr(0, new_text.length() - 1)) == 0:
			#tiling_interval.x = 0
			#box.text = str("-", new_text.substr(0, new_text.length() - 1))
		#else:
			#box.text = str(tiling_interval.x)
	#elif only_float(float(box.text), new_text)[1]:
		#tiling_interval.x = float(box.text)
	#else:
		#box.text = str(tiling_interval.x)
	#box.caret_column = new_text.length()
#
#func _on_line_edit_size_y_text_changed(new_text: String) -> void:
	#var box := $HBoxTilingSize/LineEditSizeY
	#if new_text == "":
		#tiling_interval.y = 0.0
	#elif new_text == "-":
		#tiling_interval.y = 0.0
	#elif new_text == ".":
		#tiling_interval.y = 0.0
		#box.text = "0."
		#new_text = "0."
	#elif new_text.length() >= 2 and new_text.substr(0, new_text.length() - 1).is_valid_float() and new_text[new_text.length() - 1] == "-":
		#tiling_interval.y = float(new_text.substr(0, new_text.length() - 1)) * -1.0
		#if float(new_text.substr(0, new_text.length() - 1)) == 0:
			#tiling_interval.y = 0
			#box.text = str("-", new_text.substr(0, new_text.length() - 1))
		#else:
			#box.text = str(tiling_interval.y)
	#elif only_float(float(box.text), new_text)[1]:
		#tiling_interval.y = float(box.text)
	#else:
		#box.text = str(tiling_interval.y)
	#box.caret_column = new_text.length()
#
#func _on_line_edit_negative_x_text_changed(new_text: String) -> void:
	#var box := $HBoxTilingNegative/LineEditNegativeX
	#if new_text == "":
		#negativeCorner.x = 0.0
	#elif new_text == "-":
		#negativeCorner.x = 0.0
	#elif new_text == ".":
		#negativeCorner.x = 0.0
		#box.text = "0."
		#new_text = "0."
	#elif new_text.length() >= 2 and new_text.substr(0, new_text.length() - 1).is_valid_float() and new_text[new_text.length() - 1] == "-":
		#negativeCorner.x = float(new_text.substr(0, new_text.length() - 1)) * -1.0
		#if float(new_text.substr(0, new_text.length() - 1)) == 0:
			#negativeCorner.x = 0
			#box.text = str("-", new_text.substr(0, new_text.length() - 1))
		#else:
			#box.text = str(negativeCorner.x)
	#elif only_float(float(box.text), new_text)[1]:
		#negativeCorner.x = float(box.text)
	#else:
		#box.text = str(negativeCorner.x)
	#box.caret_column = new_text.length()
#
#func _on_line_edit_negative_y_text_changed(new_text: String) -> void:
	#var box := $HBoxTilingNegative/LineEditNegativeY
	#if new_text == "":
		#negativeCorner.y = 0.0
	#elif new_text == "-":
		#negativeCorner.y = 0.0
	#elif new_text == ".":
		#negativeCorner.y = 0.0
		#box.text = "0."
		#new_text = "0."
	#elif new_text.length() >= 2 and new_text.substr(0, new_text.length() - 1).is_valid_float() and new_text[new_text.length() - 1] == "-":
		#negativeCorner.y = float(new_text.substr(0, new_text.length() - 1)) * -1.0
		#if float(new_text.substr(0, new_text.length() - 1)) == 0:
			#negativeCorner.y = 0
			#box.text = str("-", new_text.substr(0, new_text.length() - 1))
		#else:
			#box.text = str(negativeCorner.y)
	#elif only_float(float(box.text), new_text)[1]:
		#negativeCorner.y = float(box.text)
	#else:
		#box.text = str(negativeCorner.y)
	#box.caret_column = new_text.length()
#
#func _on_line_edit_positive_x_text_changed(new_text: String) -> void:
	#var box := $HBoxTilingPositive/LineEditPositiveX
	#if new_text == "":
		#positiveCorner.x = 0.0
	#elif new_text == "-":
		#positiveCorner.x = 0.0
	#elif new_text == ".":
		#positiveCorner.x = 0.0
		#box.text = "0."
		#new_text = "0."
	#elif new_text.length() >= 2 and new_text.substr(0, new_text.length() - 1).is_valid_float() and new_text[new_text.length() - 1] == "-":
		#positiveCorner.x = float(new_text.substr(0, new_text.length() - 1)) * -1.0
		#if float(new_text.substr(0, new_text.length() - 1)) == 0:
			#positiveCorner.x = 0
			#box.text = str("-", new_text.substr(0, new_text.length() - 1))
		#else:
			#box.text = str(positiveCorner.x)
	#elif only_float(float(box.text), new_text)[1]:
		#positiveCorner.x = float(box.text)
	#else:
		#box.text = str(positiveCorner.x)
	#box.caret_column = new_text.length()
#
#func _on_line_edit_positive_y_text_changed(new_text: String) -> void:
	#var box := $HBoxTilingPositive/LineEditPositiveY
	#if new_text == "":
		#positiveCorner.y = 0.0
	#elif new_text == "-":
		#positiveCorner.y = 0.0
	#elif new_text == ".":
		#positiveCorner.y = 0.0
		#box.text = "0."
		#new_text = "0."
	#elif new_text.length() >= 2 and new_text.substr(0, new_text.length() - 1).is_valid_float() and new_text[new_text.length() - 1] == "-":
		#positiveCorner.y = float(new_text.substr(0, new_text.length() - 1)) * -1.0
		#if float(new_text.substr(0, new_text.length() - 1)) == 0:
			#positiveCorner.y = 0
			#box.text = str("-", new_text.substr(0, new_text.length() - 1))
		#else:
			#box.text = str(positiveCorner.y)
	#elif only_float(float(box.text), new_text)[1]:
		#positiveCorner.y = float(box.text)
	#else:
		#box.text = str(positiveCorner.y)
	#box.caret_column = new_text.length()
#
#var tilePath := ""
#func _on_line_edit_tile_path_text_changed(new_text: String) -> void:
	#tilePath = new_text
