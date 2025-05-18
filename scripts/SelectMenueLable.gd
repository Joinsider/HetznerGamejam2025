/*
 * SPDX-FileCopyrightText: Copyright information recorded in version control history
 *
 * SPDX-License-Identifier: AGPL-3.0-or-later
 */
extends Label

@export var type : Gameconstants.Attack
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = text + " ("+ str(Gameconstants.config.attack_costs[type]) +")"
