extends Node

	
var players: Array[Player] = [null, null]

# Only supports keyboard
func get_key_string(interaction: String) -> String:
	var event := InputMap.action_get_events(interaction)[0]
	if event is InputEventKey:
		return OS.get_keycode_string(event.physical_keycode)
	return "Invalid"
