extends Node2D


@export var Player = 0
var controlls = [
 	["player0_right", "player0_up", "player0_down","player0_upgrade"],
	["player1_left", "player1_up", "player1_down","player1_upgrade"]
]

@onready var selected = $".".get_children()[0]

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(controlls[Player][1]):
		selected.get_child(0).visible = false
		selected = selected.prev
		selected.get_child(0).visible = true
	if event.is_action_pressed(controlls[Player][2]):
		selected.get_child(0).visible = false
		selected = selected.next
		selected.get_child(0).visible = true
	if event.is_action_pressed(controlls[Player][3]):
		if visible:
			visible = false
			Gamestate.players[Player].is_in_menu = false
		else:
			visible = true
			Gamestate.players[Player].is_in_menu = true
	if event.is_action_pressed(controlls[Player][0]):
		if visible == true:
			print("Call effetct")
			visible = false
			Gamestate.players[Player].is_in_menu = false
		
