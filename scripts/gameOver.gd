##SPDX-FileCopyrightText: Copyright information recorded in version control history
##
##SPDX-License-Identifier: AGPL-3.0-or-later
extends Control

var player_0_won: bool = false

func _ready():
	# Connect the button's pressed signal to our function
	$Button.connect("pressed", _on_restart_button_pressed)
	$Button.grab_focus()
	
	# Debug to see if the parameters are being received
	print("GameOver scene ready")
	
	# Get the game over parameters from the gamestate
	if get_node("/root/Gamestate").has_meta("game_over_params"):
		print("Found game_over_params in Gamestate")
		var params = get_node("/root/Gamestate").get_meta("game_over_params")
		player_0_won = params.player_0_won
		
		print("Player 0 won: ", player_0_won)
		print("Player 1 won: ", !player_0_won)
		
		# Update the win message
		update_win_message()
	else:
		print("No game_over_params found in Gamestate")

func _on_restart_button_pressed():
	# Change to the main scene
	get_tree().change_scene_to_file("res://scene/StartScreen.tscn")

func update_win_message():
	var player1_label = get_parent().get_node("Player1")
	var player2_label = get_parent().get_node("Player2")
	
	print("Updating win message")
	print("player1_label exists: ", is_instance_valid(player1_label))
	print("player2_label exists: ", is_instance_valid(player2_label))
	
	if player1_label && player2_label:
		if player_0_won:
			player1_label.text = "Player 1 Won!"
			player2_label.text = "Player 2 Lost!"
		else:
			player1_label.text = "Player 1 Lost!"
			player2_label.text = "Player 2 Won!"
	else:
		print("Could not find player labels!")
