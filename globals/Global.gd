extends Node

var rng: RandomNumberGenerator
var game_speed := 1.0
var game_state: Util.GAME_STATE = Util.GAME_STATE.MENU
@export var player: CharacterBody2D
@onready var main := self
var current_level: int
var current_zoom := 1.0
var completed_parts: Array[int] = []
