/*
 * SPDX-FileCopyrightText: Copyright information recorded in version control history
 *
 * SPDX-License-Identifier: AGPL-3.0-or-later
 */
extends Node

func _ready():
	# Defer connections to ensure nodes are ready
	call_deferred("_connect_buttons")

func _connect_buttons():
	
	# Control is now a direct child of this node (TestController)
	if has_node("Control"):
		var control_node = $Control
		
		if control_node.has_node("Player1") and control_node.has_node("Player2"):
			# Connect the Player1 button to its corresponding function
			$Control/Player1.connect("pressed", _on_player1_button_pressed)
			
			# Connect the Player2 button to its corresponding function
			$Control/Player2.connect("pressed", _on_player2_button_pressed)
		else:
			print("Error: Buttons not found in the Control node!")
			print("Player1 button exists: ", control_node.has_node("Player1"))
			print("Player2 button exists: ", control_node.has_node("Player2"))
	else:
		print("Error: Control node not found as child!")

# Called when Player 1 button is pressed
func _on_player1_button_pressed():
	# Call switch_to_gameover with Player 1 as winner (true, false)
	var gamestate = get_node("/root/Gamestate")
	gamestate.switch_to_gameover(true, false)

# Called when Player 2 button is pressed
func _on_player2_button_pressed():
	print("Player 2 button pressed")
	# Call switch_to_gameover with Player 2 as winner (false, true)
	var gamestate = get_node("/root/Gamestate")
	gamestate.switch_to_gameover(false, true)
