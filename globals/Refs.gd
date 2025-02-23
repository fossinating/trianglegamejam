extends Node

@export_group("Colors")
@export var player_color : Color = "000000"
@export var ink_color : Color = "000000"
@export var canvas_color : Color = "f2f2e9"
@export var wood_color : Color = "593d2a"

@export_group("Resource Icons")

@export_group("Packed Scenes")

@export_group("Current Chances")
@export var brother_rating_ratio := 0.5
@export var crate_rating_ratio := 0.3

func get_color_by_type(type: Util.MATERIAL_TYPE) -> Color:
	match type:
		Util.MATERIAL_TYPE.PLAYER:
			return player_color
		Util.MATERIAL_TYPE.INK:
			return ink_color
		Util.MATERIAL_TYPE.PAINTING:
			return canvas_color
		Util.MATERIAL_TYPE_TYPE.CANVAS:
			return canvas_color
		Util.PROP_TYPE.FLOOR:
			return wood_color
	print("ERROR! Could not find color for given type!")
	return Color("ffffff")
