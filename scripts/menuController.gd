extends Node2D


@export var Player = 0
var controlls = [
 	["player0_right", "player0_up", "player0_down","player0_upgrade"],
	["player1_left", "player1_up", "player1_down","player1_upgrade"]
]

@onready var selected = $".".get_children()[1]

func _ready() -> void:
	Gamestate.players[Player].attack_started.connect(_onAtack)

func _otherPlayer(player:int) -> int:
	return posmod(player + 1, 2)
	
var block = false
func _input(event: InputEvent) -> void:
	if Gamestate.players[Player]._frezed:
		return
	if event is InputEventJoypadMotion:
		print(abs(event.axis_value))
		if !event.axis==0:
			if abs(event.axis_value) < 0.6: 
				print("unsett")
				block = false
				
			if block == true:
				return
				
			if abs(event.axis_value) >= 0.98:
				print("set")
				block = true
			else:
				return
		else:
			if abs(event.axis_value) < 0.6: 
				return
	if event.is_action_pressed(controlls[Player][1]) and visible:
		selected.get_child(0).visible = false
		selected = selected.prev
		selected.get_child(0).visible = true
	if event.is_action_pressed(controlls[Player][2]) and visible:
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
			if Gamestate.players[Player].remove_coins(Gameconstants.AttackCosts[selected.atack]):
				Gamestate.players[_otherPlayer(Player)].attack(selected.atack)
			else:
				Gamestate.players[Player].show_message("Not enough money! (" + str(Gamestate.players[Player]._coins) + "/" + str(Gameconstants.AttackCosts[selected.atack]) + ")")
			visible = false
			Gamestate.players[Player].is_in_menu = false
		
func _onAtack(type:Gameconstants.Attack) -> void:
	if type == Gameconstants.Attack.FREEZE:
		visible = false
		Gamestate.players[Player].is_in_menu = false
		
