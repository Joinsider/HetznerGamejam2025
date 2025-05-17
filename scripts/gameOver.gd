extends Control

var player_1_won: bool = false
var player_2_won: bool = false

func _ready():
	# Connect the button's pressed signal to our function
	$Button.connect("pressed", _on_restart_button_pressed)
	
	# Get the game over parameters from the gamestate
	if get_node("/root/Gamestate").has_meta("game_over_params"):
		var params = get_node("/root/Gamestate").get_meta("game_over_params")
		player_1_won = params.player_1_won
		player_2_won = params.player_2_won
		
		# Update the win message
		update_win_message()

func _on_restart_button_pressed():
	# Change to the main scene
	get_tree().change_scene_to_file("res://scene/main.tscn")

func update_win_message():
	var player1_label = get_parent().get_node("Player1")
	var player2_label = get_parent().get_node("Player2")
	
	if player1_label && player2_label:
		if player_1_won && player_2_won:
			player1_label.text = "It's a Tie!"
			player2_label.text = "It's a Tie!"
		elif player_1_won:
			player1_label.text = "Player 1 Won!"
			player2_label.text = "Player 2 Lost!"
		elif player_2_won:
			player1_label.text = "Player 1 Lost!"
			player2_label.text = "Player 2 Won!"
		else:
			player1_label.text = "Game Over"
			player2_label.text = "Game Over"
