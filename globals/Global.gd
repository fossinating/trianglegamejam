extends Node

var rng: RandomNumberGenerator
var game_speed := 1.0
@export var player: CharacterBody2D
@onready var main := self
var current_level: int
var current_zoom := 1.0
var current_score := 0
var last_save_score := 0
