##SPDX-FileCopyrightText: Copyright information recorded in version control history
##
##SPDX-License-Identifier: AGPL-3.0-or-later
class_name Machine
extends Node2D

signal on_upgrade(new_level: int)

@export var Player = 0

const controlls = [
 	"player0_interact",
	"player1_interact"
]

const sprite = [
	preload("res://sprites/Server-0.tres"),
	preload("res://sprites/Server-1.tres"),
	preload("res://sprites/Server-2.tres"),
	preload("res://sprites/Server-3.tres"),
	preload("res://sprites/Server-4.tres"),
	preload("res://sprites/Server-5.tres"),
]

@export var level = 0

func _ready() -> void:
	$Sprite2D.sprite_frames = sprite[level]
	Gamestate.players[Player].add_machine(self)
	on_upgrade.connect(update_sprite)
	
func update_sprite(new_level: int):
	$Sprite2D.sprite_frames = sprite[level]
	

func _input(event: InputEvent) -> void:
	if !event.is_action_pressed(controlls[Player]):
		return
	var overlapping_bodies = $Area2D.get_overlapping_bodies()
	if !(Gamestate.players[Player] in overlapping_bodies):
		return
	_upgrade()
	
func _upgrade() -> void:
	if level >= Gameconstants.config.machine_levels.size() - 1:
		return
	var nextLevel = Gameconstants.config.machine_levels[level+1]
	if (Gamestate.players[Player].remove_coins(nextLevel.cost)):
		level+=1
		on_upgrade.emit(level)
	else:
		Gamestate.players[Player].show_message("Not enough money! (" + str(Gamestate.players[Player]._coins) + "/" + str(nextLevel.cost) + ")")

func downgrade() -> void:
	if level <= 0:
		return
	level -= 1
	on_upgrade.emit(level)

func _on_timer_timeout() -> void:
	var amount = Gameconstants.config.machine_levels[level].outcome
	Gamestate.players[Player].add_collectable_coins(amount)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if !(body == Gamestate.players[Player]):
		return
	$CenterContainer/UpgradeInfo.text = "Press " + Gamestate.get_key_string(controlls[Player]) + " to upgrade"


func _on_area_2d_body_exited(body: Node2D) -> void:
	if !(body == Gamestate.players[Player]):
		return
	$CenterContainer/UpgradeInfo.text = ""
