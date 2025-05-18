/*
 * SPDX-FileCopyrightText: Copyright information recorded in version control history
 *
 * SPDX-License-Identifier: AGPL-3.0-or-later
 */
class_name GameConfig
extends Node

var machine_levels: Array[MachineLevel]

var hopper_money_limits: Array[int]

var attack_costs: Dictionary[Gameconstants.Attack, int]

var thunderstorm_multiplier: float
var ddos_multiplier: float

#func(difficulty: int) -> int
var demand = null
var startMoney: int
var displayName: String =""

func _init(new_displayName:String,new_machine_levels: Array[MachineLevel], new_hopper_money_limits: Array[int], 
			new_attack_costs: Dictionary[Gameconstants.Attack, int], new_thunderstorm_multiplier: float, 
			new_ddos_multiplier: float, new_demand, new_startMoney:int ):
	machine_levels = new_machine_levels
	hopper_money_limits = new_hopper_money_limits
	attack_costs = new_attack_costs
	thunderstorm_multiplier = new_thunderstorm_multiplier
	ddos_multiplier = new_ddos_multiplier
	demand = new_demand
	startMoney = new_startMoney
	displayName = new_displayName
	
	
