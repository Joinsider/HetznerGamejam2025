/*
 * SPDX-FileCopyrightText: Copyright information recorded in version control history
 *
 * SPDX-License-Identifier: AGPL-3.0-or-later
 */
extends Node2D

@export var Player = 0

func _ready() -> void:
	Gamestate.players[Player].coins_updated.connect(_on_coins_updated)
	Gamestate.players[Player].machine_upgraded.connect(_on_machine_upgraded)
	_set_coins(Gamestate.players[Player]._coins)
	_set_income(Gamestate.players[Player].get_income())
	
func _on_coins_updated(coins: int):
	_set_coins(coins)
	
func _on_machine_upgraded():
	var income = Gamestate.players[Player].get_income()
	_set_income(income)
	
func _set_income(income: int) -> void:
	$Income.text = "+" + str(income)  + " $"
func _set_coins(coins: int) -> void:
	$Money.text = str(coins) + " $"
