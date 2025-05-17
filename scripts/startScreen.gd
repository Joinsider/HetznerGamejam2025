extends Node

@onready var _start_game_button = $Control/StartGame
@onready var _rules_button = $Control/GameExplanation

func _ready():
	# Connect the button's pressed signal to our function
	_start_game_button.connect("pressed", _on_restart_button_pressed)
	_rules_button.connect("pressed", _on_rules_button_pressed)

	# Debug to see if the parameters are being received
	print("GameOver scene ready")
	
func _on_restart_button_pressed():
	# Change to the main scene
	get_tree().change_scene_to_file("res://scene/main.tscn")

func _on_rules_button_pressed():
	# Change to the rules scene
	get_tree().change_scene_to_file("res://scene/ExplanationScreen.tscn")
