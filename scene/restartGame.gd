extends Control

func _ready():
	# Connect the button's pressed signal to our function
	$Button.connect("pressed", _on_restart_button_pressed)

func _on_restart_button_pressed():
	# Change to the main scene
	get_tree().change_scene_to_file("res://scene/main.tscn")
