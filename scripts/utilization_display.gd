/*
 * SPDX-FileCopyrightText: Copyright information recorded in version control history
 *
 * SPDX-License-Identifier: AGPL-3.0-or-later
 */
extends Node2D

@export var Player: int = 0

const SIZE = 180

var desired_utilization: float = 0
var current_utilization: float = 0

func _ready() -> void:
	_move_indicator(0)
	Gamestate.players[Player].utilization_updated.connect(_on_utilization_updated)

func _move_indicator(percentage: float):
	var delta = (percentage - 0.5) * SIZE
	$Indicator.position = Vector2(delta, 0)

	
func _on_utilization_updated(utilization: float):
	desired_utilization = utilization
	$Percentage.text = str(round(desired_utilization*100)) + " %"
	$Demand.text = str(Gamestate.players[Player].get_demand()) + " Req./s"
	$Performance.text = str(Gamestate.players[Player].get_performance()) + " Req./s"
	
func _physics_process(delta: float) -> void:
	var step: float = (desired_utilization - current_utilization)*5*delta
	current_utilization += step
	_move_indicator(current_utilization)
	
	
