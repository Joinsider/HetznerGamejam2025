extends Node2D

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		# If the user presses the cancel button, go back to the start screen
		get_tree().change_scene_to_file("res://scene/StartScreen.tscn")
		