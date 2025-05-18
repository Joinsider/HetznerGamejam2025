##SPDX-FileCopyrightText: Copyright information recorded in version control history
##
##SPDX-License-Identifier: AGPL-3.0-or-later
extends Node

@onready var _start_game_button = $Control/Grid/StartGame
@onready var _rules_button = $Control/Grid/GameExplanation

func _ready():
	# Connect the button's pressed signal to our function
	_start_game_button.connect("pressed", _on_restart_button_pressed)
	_rules_button.connect("pressed", _on_rules_button_pressed)
	
	# Setup keyboard navigation
	_start_game_button.focus_mode = Control.FOCUS_ALL
	_rules_button.focus_mode = Control.FOCUS_ALL
	
	# Set focus neighbors (up/down navigation) with the correct property names
	_start_game_button.focus_neighbor_bottom = _rules_button.get_path()
	_rules_button.focus_neighbor_top = _start_game_button.get_path()
	
	# Set initial focus
	_start_game_button.grab_focus()

	# Debug to see if the parameters are being received
	print("GameOver scene ready")
	
func _on_restart_button_pressed():
	# Change to the main scene
	get_tree().change_scene_to_file("res://scene/difficultySelector.tscn")

func _on_rules_button_pressed():
	# Change to the rules scene
	get_tree().change_scene_to_file("res://scene/ExplanationScreen.tscn")

# Handle key presses for focused buttons
func _unhandled_input(event):
	if event.is_action_pressed("ui_accept"):
		if _start_game_button.has_focus():
			_on_restart_button_pressed()
		elif _rules_button.has_focus():
			_on_rules_button_pressed()
