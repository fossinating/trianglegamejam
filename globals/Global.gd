extends Node

var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var game_speed := 1.0
var game_state: Util.GAME_STATE = Util.GAME_STATE.MENU
@export var player: CharacterBody3D
@onready var main := self
var current_zoom := 1.0
var cheats_enabled := false
var mouse_sens := 0.12

var completed_parts: Array[int] = []
var current_checkpoint := 0
