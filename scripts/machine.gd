class_name Machine
extends Node2D

signal on_upgrade(new_level: int)

@export var Player = 0

const controlls = [
 	"player0_interact",
	"player1_interact"
]
const sprite = [
	preload("res://sprites/Server-0.png"),
	preload("res://sprites/Server-1.png"),
	preload("res://sprites/Server-2.png"),
	preload("res://sprites/Server-3.png"),
	preload("res://sprites/Server-4.png"),
	preload("res://sprites/Server-5.png"),
]

var level = 0

func _ready() -> void:
	$Sprite2D.texture = sprite[level]
	Gamestate.players[Player].add_machine(self)
	

func _input(event: InputEvent) -> void:
	if !event.is_action_pressed(controlls[Player]):
		return
	var overlapping_bodies = $Area2D.get_overlapping_bodies()
	if !(Gamestate.players[Player] in overlapping_bodies):
		return
	level_up()
	
func level_up() -> void:
	if level >= Gameconstants.machine_levels.size() - 1:
		return
	var nextLevel = Gameconstants.machine_levels[level+1]
	if (Gamestate.players[Player].remove_coins(nextLevel.cost)):
		level+=1
		$Sprite2D.texture = sprite[level]
		on_upgrade.emit(level)
	else:
		print("Player " + str(Player) + " has not the required Money: " + str(nextLevel.cost))

func _on_timer_timeout() -> void:
	var amount = Gameconstants.machine_levels[level].outcome
	Gamestate.players[Player].add_collectable_coins(amount)
