##SPDX-FileCopyrightText: Copyright information recorded in version control history
##
##SPDX-License-Identifier: AGPL-3.0-or-later
extends Button

@export var Name: Gameconstants.ConfigName
@export var DefaultFocused : bool
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = Gameconstants.configs[Name].displayName
	pressed.connect(_on_pressed)
	if DefaultFocused:
		grab_focus()


func _on_pressed() -> void:
	Gameconstants.config = Gameconstants.configs[Name]
	get_tree().change_scene_to_file("res://scene/main.tscn")
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		# If the user presses the cancel button, go back to the start screen
		get_tree().change_scene_to_file("res://scene/StartScreen.tscn")
