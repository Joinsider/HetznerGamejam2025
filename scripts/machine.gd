extends Node2D

@export var Player = 0

const controlls = [
 	"player0_interact",
	"player1_interact"
]
const sprite = [
	preload("res://sprites/Server-0.png"),
	preload("res://sprites/Server-1.png"),
	preload("res://sprites/Server-2.png"),
	preload("res://sprites/Server-3.png"),
	preload("res://sprites/Server-4.png"),
	preload("res://sprites/Server-5.png"),
]

var level = 1

func _ready() -> void:
	$Sprite2D.texture = sprite[level]

func _input(event: InputEvent) -> void:
	if !event.is_action_pressed(controlls[Player]):
		return
	

	
