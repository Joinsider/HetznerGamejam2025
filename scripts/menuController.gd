##SPDX-FileCopyrightText: Copyright information recorded in version control history
##
##SPDX-License-Identifier: AGPL-3.0-or-later
extends Node2D


@export var Player = 0
var controlls = [
 	["player0_right", "player0_up", "player0_down","player0_upgrade"],
	["player1_left", "player1_up", "player1_down","player1_upgrade"]
]


@onready var selected = $".".get_children()[1]

func _ready() -> void:
	Gamestate.players[Player].attack_started.connect(_onAtack)
	Gamestate.players[Player].machine_upgraded.connect(_onMachine_upgraded)
	
func _otherPlayer(player:int) -> int:
	return posmod(player + 1, 2)
	
var block = false
func _input(event: InputEvent) -> void:
	if Gamestate.players[Player]._frezed:
		return
	if event is InputEventJoypadMotion:
		if event.axis==1:
			if abs(event.axis_value) < 0.6:
				block = false
				return
				
			if block == true:
				return
				
			if abs(event.axis_value) >= 0.98:
				block = true
			else:
				return
		elif event.axis==0:
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
			if Gamestate.players[Player].remove_coins(Gameconstants.config.attack_costs[selected.atack]):
				Gamestate.players[_otherPlayer(Player)].attack(selected.atack)
			else:
				Gamestate.players[Player].show_message("Not enough money! (" + str(Gamestate.players[Player]._coins) + "/" + str(Gameconstants.config.attack_costs[selected.atack]) + ")")
			visible = false
			Gamestate.players[Player].is_in_menu = false
		
func _onAtack(type:Gameconstants.Attack) -> void:
	if type == Gameconstants.Attack.FREEZE:
		visible = false
		Gamestate.players[Player].is_in_menu = false
		
func _onMachine_upgraded() -> void:
	_secretMenu(Gamestate.players[Player].get_machines(5).size() == Gamestate.players[Player]._machines.size())
	
func _secretMenu(svisible:bool):
	if svisible:
		$Sprite2D.texture = load("res://sprites/attack-container-6.png")
		$"5".next = $"6Secret"
		$"1".prev = $"6Secret"
		$"6Secret".visible = true
	else:
		$Sprite2D.texture = load("res://sprites/attack-container.png")
		$"6Secret".visible = false
		$"5".next = $"1"
		$"1".prev = $"5"
