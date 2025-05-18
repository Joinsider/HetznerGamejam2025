extends Button

@export var Name: Gameconstants.ConfigName
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = Gameconstants.configs[Name].displayName
	pressed.connect(_on_pressed)


func _on_pressed() -> void:
	Gameconstants.config = Gameconstants.configs[Name]
	get_tree().change_scene_to_file("res://scene/main.tscn")
