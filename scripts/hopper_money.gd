/*
 * SPDX-FileCopyrightText: Copyright information recorded in version control history
 *
 * SPDX-License-Identifier: AGPL-3.0-or-later
 */
extends Node2D

@export var Player: int = 0

const _sprite = [
	preload("res://sprites/1-coin.png"),
	preload("res://sprites/2-coins.png"),
	preload("res://sprites/3-coins.png"),
	preload("res://sprites/coins_pile.png"),
]

func _ready() -> void:
	Gamestate.players[Player].collectable_coins_updated.connect(_on_collectable_coins_updated)
	_on_collectable_coins_updated(0)

func _on_collectable_coins_updated(coins: int):
	$Money.text = str(coins) + " G"
	for i in range(Gameconstants.config.hopper_money_limits.size()):
		if coins > Gameconstants.config.hopper_money_limits[i]:
			continue
		$Sprite2D.texture = _sprite[i]
		break
	if $Area2D.overlaps_body(Gamestate.players[Player]) and coins !=0:
		Gamestate.players[Player].collect_coins()
		$Audio.play()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if !(body == Gamestate.players[Player]):
		return
	if Gamestate.players[Player]._collectable_coins == 0:
		return
	Gamestate.players[Player].collect_coins()
	$Audio.play()
