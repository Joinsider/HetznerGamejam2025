extends Node

	
var players: Array[Player] = [null, null]

# Reset any game over state that might be persisting
func _ready():
	if has_meta("game_over_params"):
		remove_meta("game_over_params")

# Only supports keyboard
func get_key_string(interaction: String) -> String:
	var event := InputMap.action_get_events(interaction)[0]
	if event is InputEventKey:
		return OS.get_keycode_string(event.physical_keycode)
	return "Invalid"

func switch_to_gameover(player_1_won: bool = false, player_2_won: bool = false):
	# Store the win status in global variables for the gameover scene to access
	var game_over_params = {
		"player_1_won": player_1_won,
		"player_2_won": player_2_won
	}
	
	# Store the parameters directly on self instead of trying to reference /root/Gamestate
	# which would cause recursion
	self.set_meta("game_over_params", game_over_params)
	
	# Switch to the game over scene
	get_tree().change_scene_to_file("res://scene/GameOver.tscn")

