##SPDX-FileCopyrightText: Copyright information recorded in version control history
##
##SPDX-License-Identifier: AGPL-3.0-or-later
extends Node2D

# Track current page for each player (0-based index)
var player1_current_page = 0
var player2_current_page = 0
# Number of pages per player
const PAGES_PER_PLAYER = 2
# For alternating controller displays
var current_display_xbox             = true
var controller_display_timer         = 0.0
const CONTROLLER_DISPLAY_SWITCH_TIME = 2.0


func _ready():

	# Initialize page visibility - show only first page for each player
	update_player_pages(1)
	update_player_pages(2)

	# Initialize controller UI for both players
	update_player_controls(1, Gameconstants.player1_controller_type)
	update_player_controls(2, Gameconstants.player2_controller_type)


func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		# If the user presses the cancel button, go back to the start screen
		get_tree().change_scene_to_file("res://scene/StartScreen.tscn")

	# Detect input device for player 1
	if event is InputEventKey:
		if event.is_action_pressed("player0_left") or event.is_action_pressed("player0_right"):
			update_player_controls(1, Gameconstants.ControllerType.KEYBOARD)
	elif event is InputEventJoypadButton or event is InputEventJoypadMotion:
		if event.device == 0 and (event.is_action_pressed("player0_left") or event.is_action_pressed("player0_right")):
			update_player_controls(1, Gameconstants.ControllerType.CONTROLLER)

	# Detect input device for player 2
	if event is InputEventKey:
		if event.is_action_pressed("player1_left") or event.is_action_pressed("player1_right"):
			update_player_controls(2, Gameconstants.ControllerType.KEYBOARD)
	elif event is InputEventJoypadButton or event is InputEventJoypadMotion:
		if event.device == 1 and (event.is_action_pressed("player1_left") or event.is_action_pressed("player1_right")):
			update_player_controls(2, Gameconstants.ControllerType.CONTROLLER)

	# Player 1 navigation
	if event.is_action_pressed("player0_left"):
		player1_current_page = max(0, player1_current_page - 1)
		update_player_pages(1)
	elif event.is_action_pressed("player0_right"):
		player1_current_page = min(PAGES_PER_PLAYER - 1, player1_current_page + 1)
		update_player_pages(1)

	# Player 2 navigation
	if event.is_action_pressed("player1_left"):
		player2_current_page = max(0, player2_current_page - 1)
		update_player_pages(2)
	elif event.is_action_pressed("player1_right"):
		player2_current_page = min(PAGES_PER_PLAYER - 1, player2_current_page + 1)
		update_player_pages(2)


func update_player_pages(player_num):
	var panel_node   = get_node("Player" + str(player_num) + "Panel")
	var current_page = player1_current_page if player_num == 1 else player2_current_page

	# Hide all pages
	for i in range(PAGES_PER_PLAYER):
		var page_node = panel_node.get_node("Page" + str(i + 1))
		page_node.visible = false

	# Show only the current page
	var current_page_node = panel_node.get_node("Page" + str(current_page + 1))
	current_page_node.visible = true


func update_player_controls(player_num, controller_type):
	var panel_node = get_node("Player" + str(player_num) + "Panel")

	# Update controller UI visibility for Page1
	var keyboard_controls   = panel_node.get_node_or_null("Page1/Keyboard")
	var controller_controls = panel_node.get_node_or_null("Page1/Controller")

	if keyboard_controls and controller_controls:
		# Toggle visibility based on detected control scheme
		keyboard_controls.visible = (controller_type == Gameconstants.ControllerType.KEYBOARD)
		controller_controls.visible = (controller_type != Gameconstants.ControllerType.KEYBOARD)

		if controller_type != Gameconstants.ControllerType.KEYBOARD:
			# Show the correct controller type
			var playstation_controls = controller_controls.get_node_or_null("Playstation")
			var xbox_controls        = controller_controls.get_node_or_null("Xbox")

			if playstation_controls and xbox_controls:
				playstation_controls.visible = (controller_type == Gameconstants.ControllerType.CONTROLLER and not current_display_xbox)
				xbox_controls.visible = (controller_type == Gameconstants.ControllerType.CONTROLLER and current_display_xbox)

	# Update page navigation buttons
	var keyboard_navigation   = panel_node.get_node_or_null("Keyboard")
	var controller_navigation = panel_node.get_node_or_null("Controller")

	if keyboard_navigation:
		keyboard_navigation.visible = (controller_type == Gameconstants.ControllerType.KEYBOARD)

	if controller_navigation:
		controller_navigation.visible = (controller_type != Gameconstants.ControllerType.KEYBOARD)

	# Update the main panel UI for the back button based on the latest player's controller
	# We'll use player 1's controller type for the global UI
	update_main_panel_ui(controller_type)


func update_main_panel_ui(controller_type):
	var main_panel       = get_node("Panel")
	var keyboard_back    = main_panel.get_node_or_null("Keyboard")
	var xbox_back        = main_panel.get_node_or_null("Xbox")
	var playstation_back = main_panel.get_node_or_null("Playstation")

	if keyboard_back and xbox_back and playstation_back:
		keyboard_back.visible = (controller_type == Gameconstants.ControllerType.KEYBOARD)
		xbox_back.visible = (controller_type == Gameconstants.ControllerType.CONTROLLER and current_display_xbox)
		playstation_back.visible = (controller_type == Gameconstants.ControllerType.CONTROLLER and not current_display_xbox)


func _process(delta):
	# Only update the timer if any player is using a controller
	if Gameconstants.player1_controller_type != Gameconstants.ControllerType.KEYBOARD or Gameconstants.player2_controller_type != Gameconstants.ControllerType.KEYBOARD:
		controller_display_timer += delta

		# Check if it's time to switch controller display
		if controller_display_timer >= CONTROLLER_DISPLAY_SWITCH_TIME:
			controller_display_timer = 0.0
			current_display_xbox = !current_display_xbox

			# Update the UI for both players if they're using controllers
			if Gameconstants.player1_controller_type != Gameconstants.ControllerType.KEYBOARD:
				update_player_controls(1, Gameconstants.ControllerType.CONTROLLER)
			if Gameconstants.player2_controller_type != Gameconstants.ControllerType.KEYBOARD:
				update_player_controls(2, Gameconstants.ControllerType.CONTROLLER)
