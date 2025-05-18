/*
 * SPDX-FileCopyrightText: Copyright information recorded in version control history
 *
 * SPDX-License-Identifier: AGPL-3.0-or-later
 */
extends Node2D

# Track current page for each player (0-based index)
var player1_current_page = 0
var player2_current_page = 0
# Number of pages per player
const PAGES_PER_PLAYER = 2
			

func _ready():
	# Initialize page visibility - show only first page for each player
	update_player_pages(1)
	update_player_pages(2)


func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		# If the user presses the cancel button, go back to the start screen
		get_tree().change_scene_to_file("res://scene/StartScreen.tscn")

	# Player 1 navigation (A and D keys)
	if event.is_action_pressed("player0_left"): # A key
		player1_current_page = max(0, player1_current_page - 1)
		update_player_pages(1)
	elif event.is_action_pressed("player0_right"): # D key
		player1_current_page = min(PAGES_PER_PLAYER - 1, player1_current_page + 1)
		update_player_pages(1)

	# Player 2 navigation (Left and Right arrow keys)
	if event.is_action_pressed("player1_left"): # Left arrow
		player2_current_page = max(0, player2_current_page - 1)
		update_player_pages(2)
	elif event.is_action_pressed("player1_right"): # Right arrow
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
