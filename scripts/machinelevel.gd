/*
 * SPDX-FileCopyrightText: Copyright information recorded in version control history
 *
 * SPDX-License-Identifier: AGPL-3.0-or-later
 */
class_name MachineLevel
extends Node

var outcome: int
var cost: int
var performance: int

func _init(new_outcome: int, new_cost: int, new_performance: int):
	outcome = new_outcome
	cost = new_cost
	performance = new_performance
	
