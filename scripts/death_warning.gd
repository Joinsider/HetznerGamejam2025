##SPDX-FileCopyrightText: Copyright information recorded in version control history
##
##SPDX-License-Identifier: AGPL-3.0-or-later
extends Node2D

@export var Player: int = 0

func _ready() -> void:
	Gamestate.players[Player].utilization_updated.connect(update)
	if Player == 1:
		$AnimatedSprite2D.flip_h = true
	$AnimatedSprite2D.play()
	
func update(utilization: float) -> void:
	if !visible && utilization >= 1:
		$Audio.play()
	visible = utilization >= 1
